# Set the target directory
$directory = Join-Path -Path $env:APPDATA -ChildPath '..\LocalLow\VRChat\VRChat'

# Get all .txt files sorted by modification time (descending)
$files = Get-ChildItem -Path $directory -Filter "*.txt" | Sort-Object LastWriteTime -Descending

# Initialize the matched string variable
$matchedString = $null

# Write to output so user knows this is running
Write-Host "Looking for save data, this may take awhile if you have many log files or large log files"

# Iterate through the files
foreach ($file in $files) {
    # Get the content of the file
    $content = Get-Content -Path $file.FullName

    # Find the last line containing "[🦀 Idle Home 🦀]"
    $lastLineWithPattern = $content | Where-Object { $_ -match "\[🦀 Idle Home 🦀\]" } | Select-Object -Last 1

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
