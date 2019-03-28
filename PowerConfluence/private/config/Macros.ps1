$Macros = @{
    Note = @{
        Name = "note"
        SchemaVersion = "1"
        Parameters = @{
            title=@{Default="";Required=$true}
            icon=@{Default=$true;Required=$false}
        }
        RichTextBody=$true
    }
    Tip = @{
        Name = "tip"
        SchemaVersion = "1"
        Parameters = @{
            title=@{Default="";Required=$true}
            icon=@{Default=$true;Required=$false}
        }
        RichTextBody=$true
    }
    Info = @{
        Name = "info"
        SchemaVersion = "1"
        Parameters = @{
            title=@{Default="";Required=$true}
            icon=@{Default=$true;Required=$false}
        }
        RichTextBody=$true
    }
    PageProperties = @{
        Name = "details"
        SchemaVersion = "1"
        Parameters = @{}
        RichTextBody=$true
    }
    PagePropertiesReport = @{
        Name = "detailssummary"
        SchemaVersion = "2"
        Parameters = @{
            firstcolumn=@{Default="";Required=$false}
            subtle=@{Default="";Required=$false}
            headings=@{Default="";Required=$false}
            sortBy=@{Default="";Required=$false}
            cql=@{Default="";Required=$true}
            pageSize=@{Default="30";Required=$true}
        }
        RichTextBody=$false
    }
    Status = @{
        Name = "status"
        SchemaVersion = 1
        Parameters = @{
            colour=@{Default="";Required=$true}
            title=@{Default="";Required=$true}
            subtle=@{Default=$false;Required=$false}
        }
        RichTextBody=$false
        Colors = @{
            Green="Green"
            Blue="Blue"
            Yellow="Yellow"
            Red="Red"
            Grey="Grey"
        }
    }
}