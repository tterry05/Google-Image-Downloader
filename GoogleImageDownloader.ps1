# Google Image Search Downloader
# This script downloads the first 50 images from a Google search and saves them to a specified folder

param(
    [Parameter(Mandatory=$true)]
    [string]$SearchQuery,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputFolder,

    [int]$MaxImages = 25
)

function Create-Directory {
    param([string]$path)
    
    if (-not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Created directory: $path"
    } else {
        Write-Host "Directory already exists: $path"
    }
}

function Download-GoogleImages {
    param(
        [string]$query,
        [string]$folder,
        [int]$maxImages = $MaxImages
    )
    
    # Create the output directory if it doesn't exist
    Create-Directory -path $folder
    
    # URL encode the search query
    $encodedQuery = [System.Uri]::EscapeDataString($query)
    
    # Google Image Search URL
    $searchUrl = "https://www.google.com/search?q=$encodedQuery&tbm=isch"
    
    Write-Host "Searching for: $query"
    Write-Host "Using URL: $searchUrl"
    
    try {
        # Create a web client to download the page
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
        $webClient.Headers.Add("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
        
        # Download the search results page
        $htmlContent = $webClient.DownloadString($searchUrl)
        
        # Extract image URLs using regex
        # This pattern looks for image URLs in the Google search results
        $imgRegex = 'data-src="(https?://[^"]+\.(jpg|jpeg|png|gif))"'
        $alternateRegex = '"(https?://[^"]+\.(jpg|jpeg|png|gif))"'
        
        $imageUrls = [regex]::Matches($htmlContent, $imgRegex) | ForEach-Object { $_.Groups[1].Value }
        
        # If we don't find enough with the first regex, try another pattern
        if ($imageUrls.Count -lt $maxImages) {
            $additionalUrls = [regex]::Matches($htmlContent, $alternateRegex) | ForEach-Object { $_.Groups[1].Value }
            $imageUrls += $additionalUrls
        }
        
        # Remove duplicate URLs
        $imageUrls = $imageUrls | Select-Object -Unique
        
        # Limit to the desired number of images
        $imageUrls = $imageUrls | Select-Object -First $maxImages
        
        Write-Host "Found $($imageUrls.Count) image URLs"
        
        # Download each image
        $count = 0
        foreach ($imageUrl in $imageUrls) {
            $count++
            
            # Create a filename
            $extension = if ($imageUrl -match "\.(jpg|jpeg|png|gif)") { $matches[1] } else { "jpg" }
            $fileName = Join-Path $folder "$($query.Replace(' ', '_'))_$count.$extension"
            
            try {
                Write-Host "Downloading image $count/$($imageUrls.Count): $imageUrl"
                $webClient.DownloadFile($imageUrl, $fileName)
                Write-Host "  Saved to: $fileName" -ForegroundColor Green
                
                # Add a small delay to avoid overloading the server
                Start-Sleep -Milliseconds 200
            }
            catch {
                Write-Host "  Failed to download: $imageUrl" -ForegroundColor Red
                Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        
        Write-Host "`nDownload completed!" -ForegroundColor Green
        Write-Host "Successfully downloaded $count images to $folder"
    }
    catch {
        Write-Host "An error occurred during the search/download process:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Main script execution
Write-Host "======= Google Image Downloader ======="
Write-Host "Search Query: $SearchQuery"
Write-Host "Output Folder: $OutputFolder"
Write-Host "======================================"

# Run the download function
Download-GoogleImages -query $SearchQuery -folder $OutputFolder -maxImages $MaxImages
