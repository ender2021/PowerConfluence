Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \modules\PC-Api.psm1) -Force
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \modules\PC-Content.psm1) -Force

Export-ModuleMember -Function * -Variable *