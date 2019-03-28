function Format-ConfluenceHtmlTableRow($Cells) {
    $cellTags = @()
    foreach ($cell in $Cells) {$cellTags += "<{0}{2}>{1}</{0}>" -f (""+$cell.Type),(""+$cell.Contents),(&{if($cell.Center){' style="text-align: center;"'}else{''}})}
    "<tr>$cellTags</tr>"
}