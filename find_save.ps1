function GetLastLineWithPattern($filePath, $pattern) {
    $fileStream = New-Object System.IO.FileStream($filePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
    $reader = New-Object System.IO.StreamReader($fileStream, [System.Text.Encoding]::Default)
    $lastLineWithPattern = $null

    try {
        while (($line = $reader.ReadLine()) -ne $null) {
            if ($line -match $pattern) {
                $lastLineWithPattern = $line
                # Removed break statement
            }
        }
    }
    finally {
        $reader.Close()
        $fileStream.Close()
    }

    return $lastLineWithPattern
}

# Set the target directory
$directory = Join-Path -Path $env:APPDATA -ChildPath '..\LocalLow\VRChat\VRChat'

# Get all .txt files sorted by modification time (descending)
$files = Get-ChildItem -Path $directory -Filter "*.txt" | Sort-Object LastWriteTime -Descending

# Initialize the matched string variable
$matchedString = $null

# Iterate through the files
foreach ($file in $files) {
    # Find the last line containing "[🦀 Idle Home 🦀] Saved"
    $lastLineWithPattern = GetLastLineWithPattern -filePath $file.FullName -pattern "\[🦀 Idle Home 🦀\] Saved"

    # Check the last line with the save data
    if ($null -ne $lastLineWithPattern) {
        # Extract all characters after the last space character
        $matchedString = $lastLineWithPattern.Split(" ")[-1]

        # Break the loop if the matched string is found
        if ($null -ne $matchedString) {
            break
        }
    }
}

# Check if the save data is found
if ($null -ne $matchedString) {
    # Copy the extracted save data to clipboard
    Set-Clipboard -Value $matchedString

    # Display the copied data for debug reasons
    Write-Host "Copied save to clipboard: $matchedString"
} else {
    Write-Host "The desired string was not found in any of the files."
}
