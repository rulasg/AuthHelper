# Managing dependencies

$MODULE_INVOKATION_TAG = ""

function Get-InvokeModuleTag{
    if( [string]::IsNullOrWhiteSpace($MODULE_INVOKATION_TAG)){
        $local = $PSScriptRoot
        $root = $local | Split-Path -Parent | Split-Path -LeafBase
        $MODULE_INVOKATION_TAG = $root+"Module"
    }

    return $MODULE_INVOKATION_TAG
}

function Set-MyInvokeCommandAlias{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)][string]$Alias,
        [Parameter(Mandatory,Position=1)][string]$Command
    )

    $tag = Get-InvokeModuleTag

    if ($PSCmdlet.ShouldProcess("InvokeCommandAliasList", ("Add Command Alias [{0}] = [{1}]" -f $Alias, $Command))) {
        InvokeHelper\Set-InvokeCommandAlias -Alias $Alias -Command $Command -Tag $tag
    }
}