# map structure pseudocode:
# $map = $(sections)   # sections are either a bool ($true = UserSection) or an array of bools
# 
# Example:
# $map = $($true,$($true,$false),$($false,$true,$false))
# ----------------------------------------------------
# |       SINGLE COLUMN USER SECTION                 |
# ----------------------------------------------------
# ----------------------------------------------------
# |     USER CELL       |     GENERATED CELL         |
# ----------------------------------------------------
# ----------------------------------------------------
# |  GEN. CELL    |   USER CELL    |    GEN. CELL    |      
# ---------------------------------------------------- 

function Split-ConfluenceLayout($StorageFormat,$StartToken,$EndToken)
{
    #start a list
    $sections = @()
    
    # find the starting indexes of the $StartToken in the entire body and loop through them
    $startMatches = [regex]::Matches($StorageFormat, $StartToken)
    foreach ($match in $startMatches) {
        # start by taking the part of the string that occurs after the start of the StartToken
        $section = $StorageFormat.Substring($match.Index)

        # now chop off everything after the end of the first EndToken in the remaining string
        $section = $section.Substring(0, ([regex]::Matches($section, $EndToken))[0].Index + $EndToken.Length)

        # add the trimmed section to the list
        $sections += $section
    }

    #return the list
    $sections
}