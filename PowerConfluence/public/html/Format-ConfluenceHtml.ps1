function Format-ConfluenceHtml($Tag,$Contents="") {
    (&{if($Contents -ne ""){"<$Tag>$Contents</$Tag>"}else{"<$Tag />"}})
}