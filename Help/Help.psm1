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
#    [eHelpSynopsis('Simple calculator class for basic arithmetic operations.')]
#    [eHelpDescription('This class provides basic arithmetic operations such as addition.')]
#    [eHelpNotes('This is a demo class for illustrating the use of eHelpAttributes for documentation.')]
#    [eHelpLink('https://example.com/CalculatorHelp')]
#    class Calculator {
#        [eHelpProperty('property1', 'This is a sample property.')]
#        [string] $property1
#
#        Calculator() {}
#
#        # Method to add two numbers with documentation
#        [eHelpSynopsis('Adds two numbers and returns the sum.')]
#        [eHelpDescription('This method takes two integers as input and returns their sum.')]
#        [eHelpParameter('num1', 'The first number to add.')]
#        [eHelpParameter('num2', 'The second number to add.')]
#        [eHelpExample(@'
#    PS> $calc = [Calculator]::new()
#    PS> $calc.Add(5, 4)
#    9
#    '@)]
#        [int] Add([int] $num1, [int] $num2) {
#            return $num1 + $num2
#        }
#
#        # Help method to get the help documentation for the class
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
    
    // This class is the base class for all named-attribute eHelp attributes
    public class eHelpNamedAttribute : Attribute
    {
        public string Name { get; set; }
        public string Content { get; set; }
    
        public eHelpNamedAttribute(string name, string content)
        {
            this.Name = name;
            this.Content = content;
        }
    }

    // This class is the base class for all named-attribute eHelp attributes that require a type (like parameters)
    public class eHelpTypedAttribute : eHelpNamedAttribute
    {
        public string TypeName { get; set; }
    
        public eHelpTypedAttribute(string name, string content, string typeName) : base(name, content)
        {
            this.TypeName = typeName;
        }
    }
        
    // This class is used to attach a help synopsis to a class
    public class eHelpSynopsis : eHelpAttribute
    {
        public eHelpSynopsis() : base("") { }
        public eHelpSynopsis(string content) : base(content) { }
    
        public override string ToString()
        {
            return ".SYNOPSIS\n" + this.Content;
        }
    }
    
    // This class is used to attach a help description to a class
    public class eHelpDescription : eHelpAttribute
    {
        public eHelpDescription() : base("") { }
        public eHelpDescription(string content) : base(content) { }
    
        public override string ToString()
        {
            return ".DESCRIPTION\n" + this.Content;
        }
    }
    
    // This class is used to attach a help notes section to a class
    public class eHelpNotes : eHelpAttribute
    {
        public eHelpNotes() : base("") { }
        public eHelpNotes(string content) : base(content) { }
    
        public override string ToString()
        {
            return ".NOTES\n" + this.Content;
        }
    }
    
    // This class is used to attach a help link to a class
    public class eHelpLink : eHelpAttribute
    {
        public eHelpLink() : base("") { }
        public eHelpLink(string content) : base(content) { }
    
        public override string ToString()
        {
            return ".LINK\n" + this.Content;
        }
    }
    
    // This class is used to attach a parameter's help to a class
    public class eHelpParameter : eHelpTypedAttribute
    {
        public eHelpParameter() : base("", "", "object") { }
        public eHelpParameter(string name, string content) : base(name, content, "object") { }
        public eHelpParameter(string name, string content, string typeName) : base(name, content, typeName) { }
    
        public override string ToString()
        {
            return ".PARAMETER " + this.Name + " [" + this.Type + "]\n" + this.Content;
        }
    }
    
    // This class is used to attach an example to a class
    public class eHelpExample : eHelpAttribute
    {
        public eHelpExample() : base("") { }
        public eHelpExample(string content) : base(content) { }
    
        public override string ToString()
        {
            return ".EXAMPLE\n" + this.Content;
        }
    }
    
    // This class is used to attach a property's help to a class
    public class eHelpProperty : eHelpNamedAttribute
    {
        public eHelpProperty() : base("", "") { }
        public eHelpProperty(string name, string content) : base(name, content) { }
    
        public override string ToString()
        {
            return ".PROPERTY " + this.Name + "\n" + this.Content;
        }
    }

    // This class is used to attach a return value's help to a class
    public class eHelpOutputs : eHelpAttribute
    {
        public eHelpOutputs() : base("") { }
        public eHelpOutputs(string content) : base(content) { }
    
        public override string ToString()
        {
            return ".RETURN\n" + this.Content;
        }
    }

'@ -Language CSharp
    #endregion
#╚═══HELP═════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
