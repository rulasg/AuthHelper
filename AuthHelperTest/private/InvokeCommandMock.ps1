# Managing dependencies
$MODULE_INVOKATION_TAG = ""

function Get-InvokeModuleTag{
    if( [string]::IsNullOrWhiteSpace($MODULE_INVOKATION_TAG)){
        $local = $PSScriptRoot
        $root = $local | Split-Path -Parent | Split-Path -Parent | Split-Path -LeafBase
        $MODULE_INVOKATION_TAG = $root+"Module_Mock"
    }

    return $MODULE_INVOKATION_TAG
}

function Set-InvokeCommandMock{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$Alias,
        [Parameter(Mandatory,Position=1)][string]$Command
    )

    $tag = Get-InvokeModuleTag

    InvokeHelper\Set-InvokeCommandAlias -Alias $Alias -Command $Command -Tag $tag
} 

function Reset-InvokeCommandMock{
    [CmdletBinding()]
    param()

    InvokeHelper\Reset-InvokeCommandAlias -Tag $MODULE_INVOKATION_TAG
} Export-ModuleMember -Function Reset-InvokeCommandMock

function MockCall{
    param(
        [string] $command,
        [string] $filename

    )

    $root = $PSScriptRoot | Split-Path -Parent
    $mockFile = $root | Join-Path -ChildPath 'public' -AdditionalChildPath 'testData', $filename
    Set-InvokeCommandMock -Alias $command -Command "Get-Content -Path $(($mockFile | Get-Item).FullName)"
}

function MockCallToString{
    param(
        [string] $command,
        [string] $OutString
    )

    $outputstring = 'echo "{output}"'
    $outputstring = $outputstring -replace "{output}", $OutString

    Set-InvokeCommandMock -Alias $command -Command $outputstring
}

function MockCallToNull{
    param(
        [string] $command
    )

    Set-InvokeCommandMock -Alias $command -Command 'return $null'
}

function MockCallThrow{
    param(
        [string] $command

    )
    Set-InvokeCommandMock -Alias $command -Command "throw"
}

Reset-InvokeCommandMock