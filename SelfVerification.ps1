$ErrorActionPreference = 'Stop'

function Get-Answer {
    param (
        [string]$question,
        [string[]]$answers,
        [int]$ca
    )
    $answerFound = $false
    do {
        Clear-Host
        $questionNumber = 0
        Write-Host "$question"
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
        if (! [string]::IsNullOrEmpty($ca)){
            [psobject]@{
                isAnswerCorrect = $answerNumber -eq $($ca + 1);
                question = $question;
                answer = $answers[$answerNumber - 1]
            }
        } else{
            $answers[$answerNumber - 1]
        }
    }
}

try{
    $XMLPath = "$PSScriptRoot\Questions.xml"
    if (!(Test-Path $XMLPath)){
        $TmpPath = New-TemporaryFile 
        $url = 'https://raw.githubusercontent.com/Vector-BCO/PowerShell.Learning/master/Questions.xml'
        Start-BitsTransfer -Source $url -Destination $TmpPath
        $XMLPath = $TmpPath
    } 

    if (Test-Path $XMLPath){
        $QuestionsXML = $([xml](Get-Content $XMLPath -Encoding UTF8)).Questions.question
        $languages = $QuestionsXML | Select-Object -ExpandProperty lang -Unique
        $SelectedLanguage = $languages | Select-Object -First 1
        if (($languages | Measure-Object).count -gt 1){
            Get-Answer -Qusetion "Select language from the list" -Answers $languages
        }
        $Questions = $QuestionsXML | Where-Object {$_.lang -eq $SelectedLanguage}
        $answers = @()
        foreach ($Question in $Questions){
            $ReceivedAnswer = Get-Answer -question $Question.text.'#cdata-section' -answers $Question.Answers.answer -ca $Question.ca
            if ($ReceivedAnswer.isAnswerCorrect){
                Write-Host "Correct answer" -ForegroundColor Green
            } else {
                Write-Host "Incorrect answer" -ForegroundColor Red
            }
            $answers += $ReceivedAnswer
            Start-Sleep -s 2
        }

        $answers = $answers | Foreach-Object {$_ | Select-Object @{n='question'; e={$_.question}}, @{n='answer'; e={$_.answer}}, @{n='IsAnswerCorrect'; e={$_.isAnswerCorrect}}}
        $correctAnswer = ($($answers | Where-Object {$_.IsAnswerCorrect -eq $true} | Measure-Object).count * 100) / $($answers | Measure-Object).count
        Write-Host "Correct answers: $correctAnswer%"
        $answers | Out-GridView
    } else {
        Throw "Questions.xml not be found, place questions.xml from GitHub to the same folder as this script is."
    }
} Catch {
    Write-Host "[SelfVerification] Script failed with error: $_"
}
