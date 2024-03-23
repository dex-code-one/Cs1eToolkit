 # This submodule file contains all of the classes and functions related specifically
 # to the help system for the eToolkit.  Using these classes, one can easily add
 # help information to their classes, properties, and methods.  The Get-HelpAttributes
 # function can be used to retrieve the help information for a class by passing the
 # class type to the function.  The help information will be displayed in the console.
 
 
 # This class is the base class for all single-attribute eHelp attributes
 class eHelpAttribute : System.Attribute {
    [string] $Content;
    
    eHelpAttribute([string] $Content) {
        $this.Content = $Content
    }
}

# This class is the base class for all named-attribute eHelp attributes
class eHelpNamedAttribute : System.Attribute {
   [string] $Name;
   [string] $Content;
   
   eHelpNamedAttribute([string] $Name, [string] $Content) {
       $this.Name = $Name
       $this.Content = $Content
   }
}



# This class is used to attach a help synopsis to a class
class eHelpSynopsis : eHelpAttribute {
    eHelpSynopsis() : base('') {}
    eHelpSynopsis([string] $Content) : base($Content) {}
    [string] ToString() {return ".SYNOPSIS`n" + $this.Content}
}

# This class is used to attach a help description to a class
class eHelpDescription : eHelpAttribute {
    eHelpDescription() : base('') {}
    eHelpDescription([string] $Content) : base($Content) {}
    [string] ToString() {return ".DESCRIPTION`n" + $this.Content}
}

# This class is used to attach a help notes section to a class
class eHelpNotes : eHelpAttribute {
    eHelpNotes() : base('') {}
    eHelpNotes([string] $Content) : base($Content) {}
    [string] ToString() {return ".NOTES`n" + $this.Content}
}

# This class is used to attach a help link to a class
class eHelpLink : eHelpAttribute {
    eHelpLink() : base('') {}
    eHelpLink([string] $Content) : base($Content) {}
    [string] ToString() {return ".LINK`n" + $this.Content}
}

# This class is used to attach a parameter's help to a class
class eHelpParameter : eHelpNamedAttribute{
   eHelpParameter() : base('','') {}
   eHelpParameter([string] $Name, [string] $Content) : base($Name, $Content) {}
   [string] ToString() {return '.PARAMETER ' + $this.Name + "`n" + $this.Content}
}

# This class is used to attach an example to a class
class eHelpExample : eHelpAttribute {
    eHelpExample() : base('') {}
    eHelpExample([string] $Content) : base($Content) {}
    [string] ToString() {return ".EXAMPLE`n" + $this.Content}
}

# This class is used to attach a property's help to a class
class eHelpProperty : eHelpNamedAttribute {
    eHelpProperty() : base('','') {}
    eHelpProperty([string] $Name, [string] $Content) : base($Name, $Content) {}
    [string] ToString() {return '.PROPERTY ' + $this.Name + "`n" + $this.Content}
}

# This class is used to get help documentation for a class
class eHelp {
    static [string] GetHelp([object] $target) {

        $sb = [System.Text.StringBuilder]::new()
        $type = $target.GetType()

        # BindingFlags to specify that you only want items declared in the class itself
        $bindingFlags = [System.Reflection.BindingFlags]::Public -bor [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::DeclaredOnly

        # Get the documentation for the class
        [void]$sb.AppendLine((New-Separator -Type ThickTop -Length 80 -Name $type.Name -NewLineBefore))
        [void]$sb.AppendLine((New-Separator -Type DoubleTop -Length 78 -Name 'CLASS DOCUMENTATION' -NewLineBefore -IndentSize 2))
        $Attributes = $type.GetCustomAttributes($true)
        foreach ($Attribute in $Attributes) {
            [void]$sb.AppendLine("`n$(Add-Indentation $Attribute.ToString() -IndentSize 4)")
        }
        [void]$sb.AppendLine((New-Separator -Type DoubleBottom -Length 78 'CLASS DOCUMENTATION' -NewLineBefore -IndentSize 2))

        # Get the documentation for the class's properties
        [void]$sb.AppendLine((New-Separator -Type DoubleTop -Length 78 -Name 'CLASS PROPERTIES' -NewLineBefore -IndentSize 2))
        $Properties = $type.GetProperties()
        foreach ($Property in $Properties) {
            $Attributes = $Property.GetCustomAttributes($true)
            foreach ($Attribute in $Attributes) {
                [void]$sb.AppendLine("`n$(Add-Indentation $Attribute.ToString() -IndentSize 4)")
            }
        }
        [void]$sb.AppendLine((New-Separator -Type DoubleBottom -Length 78 -Name 'CLASS PROPERTIES' -NewLineBefore -IndentSize 2))

        # Get the documentation for the class's methods
        [void]$sb.AppendLine((New-Separator -Type DoubleTop -Length 78 -Name 'CLASS METHODS' -NewLineBefore -IndentSize 2))
        $Methods = $type.GetMethods($bindingFlags)
        foreach ($Method in $Methods) {
            $Attributes = $Method.GetCustomAttributes($true)
            if ($Attributes.Count -gt 0) {
                [void]$sb.AppendLine((New-Separator -Type SingleTop -Length 74 -Name $Method.Name -NewLineBefore -IndentSize 4))
                foreach ($Attribute in $Attributes) {
                    [void]$sb.AppendLine("`n$(Add-Indentation $Attribute.ToString() -IndentSize 6)")
                }
                [void]$sb.AppendLine((New-Separator -Type SingleBottom -Length 74 -Name $Method.Name -NewLineBefore -IndentSize 4))
            }
        }
        [void]$sb.AppendLine((New-Separator -Type DoubleBottom -Length 78 -Name 'CLASS METHODS' -NewLineBefore -IndentSize 2))
        [void]$sb.AppendLine((New-Separator -Type ThickBottom -Length 80 -Name $type.Name -NewLineBefore))

        return $sb.ToString()
    }
}

<#

# a sample class to demonstrate the use of eHelp attributes

# Attach help documentation to the class
[eHelpSynopsis('Simple calculator class for basic arithmetic operations.')]
[eHelpDescription('This class provides basic arithmetic operations such as addition.')]
[eHelpNotes('This is a demo class for illustrating the use of eHelpAttributes for documentation.')]
[eHelpLink('https://example.com/CalculatorHelp')]
class Calculator {
    [eHelpProperty('property1', 'This is a sample property.')]
    [string] $property1

    Calculator() {}

    # Method to add two numbers with documentation
    [eHelpSynopsis('Adds two numbers and returns the sum.')]
    [eHelpDescription('This method takes two integers as input and returns their sum.')]
    [eHelpParameter('num1', 'The first number to add.')]
    [eHelpParameter('num2', 'The second number to add.')]
    [eHelpExample(@'
PS> $calc = [Calculator]::new()
PS> $calc.Add(5, 4)
9
'@)]
    [int] Add([int] $num1, [int] $num2) {
        return $num1 + $num2
    }

    # Help method to get the help documentation for the class
    [string] Help() {
        return [eHelp]::GetHelp($this)
    }
}

$calc = [Calculator]::new()
$calc.Help()

#>