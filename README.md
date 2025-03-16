# Google Image Downloader

This PowerShell script allows you to download images from Google Image Search based on a specified search query. It retrieves the first set of images and saves them to a designated folder on your system.

## Features

- Downloads images from Google Image Search.
- Allows specifying the number of images to download (default is 25).
- Automatically creates the output folder if it doesn't exist.
- Handles duplicate image URLs and skips failed downloads.

## Requirements

- Windows PowerShell
- Internet connection

## Parameters

| Parameter      | Description                                                                 | Mandatory | Default Value |
|----------------|-----------------------------------------------------------------------------|-----------|---------------|
| `SearchQuery`  | The search term to query Google Images.                                     | Yes       | N/A           |
| `OutputFolder` | The folder where the downloaded images will be saved.                      | Yes       | N/A           |
| `MaxImages`    | The maximum number of images to download.                                  | No        | 25            |

## Usage

1. Open PowerShell.
2. Run the script with the required parameters. For example:

   ```powershell
   .\GoogleImageDownloader.ps1 -SearchQuery "puppies" -OutputFolder "C:\Images" -MaxImages 50
   ```

   - Replace `"puppies"` with your desired search term.
   - Replace `"C:\Images"` with the path to your desired output folder.
   - Optionally, specify the number of images to download using `-MaxImages`.

## Example Use Case

Imagine you need 25 random images of different flavors of ice cream and don't want to manually download each one. You can use this script to automate the process:

```powershell
.\GoogleImageDownloader.ps1 -SearchQuery "ice cream flavors" -OutputFolder "C:\Images\IceCream" -MaxImages 25
```

This will download 25 images of ice cream flavors and save them to the specified folder.

## Example Output

```
======= Google Image Downloader =======
Search Query: puppies
Output Folder: C:\Images
======================================
Searching for: puppies
Using URL: https://www.google.com/search?q=puppies&tbm=isch
Found 50 image URLs
Downloading image 1/50: https://example.com/image1.jpg
  Saved to: C:\Images\puppies_1.jpg
...
Download completed!
Successfully downloaded 50 images to C:\Images
```

## Notes

- The script uses regex to extract image URLs from the Google search results page. If Google changes its page structure, the script may require updates.
- A small delay is added between downloads to avoid overloading the server.
- Ensure you comply with Google's terms of service when using this script.

## Disclaimer

This script is provided as-is without any warranty. Use it at your own risk. The author is not responsible for any misuse or violations of third-party terms of service.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
