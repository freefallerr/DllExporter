<#
.DESCRIPTION
    A script which wraps DumpBin.exe to fun the exported functions in a DLL and create a list which can be pasted into a DLL. 
.PARAMETER DllLocation
	Specify application name of the DLL we are proxying.
.EXAMPLE
	exporter.ps1 -DllName "C:\Windows\System32\TextShaping.dll" -Out "C:\Users\me\Desktop\out.txt"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$DllLocation
)

if(-not $DllLocation.EndsWith(".dll"))
{
    $DllLocation = $DllLocation + ".dll"
    Write-Host "$DllLocation"
}

$DumpPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.34.31933\bin\Hostx86\x86\DumpBin.exe"

#Strip filepath and extension for later use
$DllName = (Get-Item "$DllLocation").BaseName

# Run DumpBin.exe with the exports switch and capture the output, print to console.
& $DumpPath -exports $DllLocation | 
    Select-String -Pattern '^\s+\d+\s+\w+\s+[\dA-F]+\s+(.+)$' | 
    ForEach-Object { 
        $_.Matches[0].Groups[0].Value.Trim()
    } | 
    ForEach-Object { 
        $columns = $_ -split ' +'
        $ordinal = $columns[0]
        $functionName = $columns[-1]
        Write-Host "#pragma comment(linker,"`"/export:$functionName=$DllName.$functionName","@$ordinal"`")"
    }
