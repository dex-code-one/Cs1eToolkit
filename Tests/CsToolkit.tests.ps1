
# [Encryption] class tests
####################################################################################################
Describe "Encryption class" {
    BeforeAll {
        # Create some test data
        $testString = "Test"
        $testByteArray = [Defaults]::Encoding.GetBytes($testString)
        $testSecureString = ConvertTo-SecureString "Test" -AsPlainText -Force
        $testPSCredential = New-Object System.Management.Automation.PSCredential ("TestUser", $testSecureString)
    }

    It "Converts byte array to secure string" {
        $result = $encryption::ConvertByteArrayToSecureString($testByteArray)
        $result | Should -BeOfType System.Security.SecureString
    }

    It "Converts PSCredential to byte array" {
        $result = $encryption::ConvertPSCredentialToByteArray($testPSCredential)
        $result | Should -BeOfType [byte[]]
    }

    It "Converts secure string to byte array" {
        $result = $encryption::ConvertSecureStringToByteArray($testSecureString)
        $result | Should -BeOfType [byte[]]
    }

    It "Encrypts and decrypts byte array" {
        $encryptedData = $encryption::EncryptByteArray($testByteArray, $testByteArray, $testByteArray)
        $decryptedData = $encryption::DecryptByteArray($encryptedData, $testByteArray)
        $decryptedData | Should -Be $testByteArray
    }

    It "Encrypts and decrypts secure string" {
        $encryptedData = $encryption::EncryptSecureString($testByteArray, $testByteArray, $testByteArray)
        $decryptedData = $encryption::DecryptSecureString($encryptedData, $testByteArray)
        $decryptedData | Should -Be $testSecureString
    }

    It "Encrypts and decrypts string" {
        $encryptedData = $encryption::EncryptString($testByteArray, $testByteArray, $testByteArray)
        $decryptedData = $encryption::DecryptString($encryptedData, $testByteArray)
        $decryptedData | Should -Be "Test"
    }
}