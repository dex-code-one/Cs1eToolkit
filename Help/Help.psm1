#╔═══HELP═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
#    This region contains all of the classes and functions related specifically
#    to the help system for the eClass module.  Using these classes, one can easily
#    add help information to their classes, properties, and methods.  This region
#    must be included first in the module file in order for the eHelp attributes to
#    be available to document the rest of the module.

#    ========================================================
#    ********************************************************

#    NOTE: The reason this is in a separate module is because the eHelp attributes
#    are not available to the module until after the module is loaded.  By putting
#    this in a separate module, we can ensure that the eHelp attributes are available
#    to the rest of the module and we can add help information to the classes right away

#    ********************************************************
#    ========================================================

#
#    Here's an example of how to attach help documentation to a class using eHelp
#
#    [eHelpAttribute(@'
#    .SYNOPSIS
#    This is a sample class that demonstrates how to use eHelp attributes to document a class.
#    .DESCRIPTION
#    This class provides basic arithmetic operations such as addition.
#    .LINK
#    https://example.com/CalculatorHelp
#    '@)]
#    class Calculator {
#        [eHelpAttribute(@'
#        .PROPERTY property1 [string]
#        This is a sample property that demonstrates how to use eHelp attributes to document a property.
#        '@)]
#        [string] $property1
#
#        [eHelpAttribute(@'
#        .SYNOPSIS
#        Empty constructor.
#        .DESCRIPTION
#        This constructor does nothing.
#        '@)]
#        Calculator() {}
#
#        [eHelpAttribute(@'
#        .SYNOPSIS
#        Adds two numbers and returns the sum.
#        .DESCRIPTION
#        This method takes two integers as input and returns their sum.
#        .PARAMETER num1 [int]
#        The first number to add.
#        .PARAMETER num2 [int]
#        The second number to add.
#        .EXAMPLE
#        $calc = [Calculator]::new()
#        $calc.Add(5, 4)
#        9
#        .NOTES
#        This is a sample note.
#        .LINK
#        https://example.com/CalculatorAddHelp
#        '@)]
#        [int] Add([int] $num1, [int] $num2) {
#            return $num1 + $num2
#        }
#
#        [eHelpAttribute(@'
#        .SYNOPSIS
#        Displays the help for this class.
#        .DESCRIPTION
#        This method displays the help for this class.
#        '@)]
#        [string] Help() {
#            return [eHelp]::GetHelp($this)
#        }
#    }
#
#    # Now create an instance of the class and display the help
#    $calc = [Calculator]::new()
#    $calc.Help()

    Add-Type -TypeDefinition @'
    using System;

    // This class is the base class for all single-attribute eHelp attributes
    public class eHelpAttribute : Attribute
    {
        public string Content { get; set; }
    
        public eHelpAttribute(string content)
        {
            this.Content = content;
        }
    }

'@ -Language CSharp
    #endregion
#╚═══HELP═════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
