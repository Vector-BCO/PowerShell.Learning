$ErrorActionPreference = 'Stop'

Function Get-MDHash {
    param (
        [string]$Question,
        [string]$Answer
    )
    $string = $Question + $Answer
    $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $utf8 = New-Object -TypeName System.Text.UTF8Encoding
    [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($string)))
}

function Get-Answer {
    param (
        [string]$question,
        [string[]]$answers,
        [AllowEmptyString()]
        [string]$correctAnswer
    )
    $answerFound = $false
    do {
        Clear-Host
        $questionNumber = 0
        Write-Host "$question"
        Write-Host '--------------------------------------'
        foreach ($answer in $answers){
            $questionNumber++
            Write-Host "[$questionNumber] $($answer -split '\n' | Where-Object {$_ -notmatch '^\s*$'} | Out-String)"
        }
        $answerNumber = Read-Host -Prompt "Select answer 1 - $questionNumber"
        if ($answerNumber -in @(1..$questionNumber)) {
            $answerFound = $true
        } else {
            Write-Host "Provided incorrect answer. Please try again" -foreground Yellow
            Start-Sleep -s 2
        }
    } until ( $answerFound )
    if ($answerFound){
        if (! [string]::IsNullOrEmpty($correctAnswer)){
            [psobject]@{
                isAnswerCorrect = $correctAnswer -eq $(Get-MDHash -Question $question -Answer $answers[$answerNumber - 1]);
                question = $question;
                answer = $answers[$answerNumber - 1]
            }
        } else{
            [psobject]@{
                isAnswerCorrect = $(Get-MDHash -Question $question -Answer $answers[$answerNumber - 1]);
                question = $question;
                answer = $answers[$answerNumber - 1]
            }
        }
    }
}

try{
    $QuestionPath = "$PSScriptRoot\questions.json"
    if (!(Test-Path $QuestionPath)){
        $TmpPath = New-TemporaryFile 
        $url = 'https://raw.githubusercontent.com/Vector-BCO/PowerShell.Learning/master/questions.json'
        Start-BitsTransfer -Source $url -Destination $TmpPath
        $QuestionPath = $TmpPath
    } 

    if (Test-Path $QuestionPath){
        $QuestionsWithLanguages = (Get-Content $QuestionPath -Encoding UTF8 | ConvertFrom-Json).Languages
        $languages = $QuestionsWithLanguages | Select-Object -ExpandProperty Language -Unique
        $SelectedLanguage = $languages | Select-Object -First 1
        if (($languages | Measure-Object).count -gt 1){
            $ReceivedAnswer = Get-Answer -question "Select language from the list" -answers $languages
            $SelectedLanguage = $ReceivedAnswer.answer
        }
        $QuestionsWithLanguages = $QuestionsWithLanguages | Where-Object {$_.Language -eq $SelectedLanguage} | Select-Object -ExpandProperty questionCategories
        $answers = @()
        foreach ($Category in $QuestionsWithLanguages){
            $CategoryName = $Category.category
            Write-Host "Category started: '$CategoryName'"
            foreach ($question in $Category.questions){
                $ReceivedAnswer = Get-Answer -question $Question.question -answers $Question.answers -correctAnswer "$($Question.correctAnswer)"
                if ($ReceivedAnswer.isAnswerCorrect -eq $true){
                    Write-Host "Correct answer" -ForegroundColor Green
                } else {
                    Write-Host "Incorrect answer" -ForegroundColor Red
                }
                $answers += $ReceivedAnswer
                Start-Sleep -s 1
            }
        }

        $answers = $answers | Foreach-Object {$_ | Select-Object @{n='question'; e={$_.question}}, @{n='answer'; e={$_.answer}}, @{n='IsAnswerCorrect'; e={$_.isAnswerCorrect}}}#, @{n='hash'; e={$_.hash}}}
        $correctAnswerPercentage = ($($answers | Where-Object {$_.IsAnswerCorrect -eq $true} | Measure-Object).count * 100) / $($answers | Measure-Object).count
        $correctAnswerPercentage = [math]::Round($correctAnswerPercentage, 2)
        Write-Host "Correct answers: $correctAnswerPercentage%"
        $answers | Out-GridView
    } else {
        Throw "Questions.xml not be found, place questions.xml from GitHub to the same folder as this script is."
    }
} Catch {
    Write-Host "[SelfVerification] Script failed with error: $_"
}