BeforeDiscovery {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent
    $moduleManifestPath = Join-Path -Path $repoRoot -ChildPath 'DattoRMM.psd1'
    $moduleName = 'DattoRMM'

    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $moduleManifestPath -Force
}

BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent
    $moduleManifestPath = Join-Path -Path $repoRoot -ChildPath 'DattoRMM.psd1'
    $moduleName = 'DattoRMM'

    $validApiUrl = 'https://merlot-api.centrastage.net'

}

Describe 'DattoRMM module surface' -Tag 'Unit' {
    It 'imports the module successfully' {
        Get-Module -Name 'DattoRMM' | Should -Not -BeNullOrEmpty
    }

    It 'exports every function script in the functions folder' {
        $repoRoot = Split-Path -Path $PSScriptRoot -Parent
        $functionFiles = Get-ChildItem -Path (Join-Path -Path $repoRoot -ChildPath 'functions') -Filter '*.ps1' -File
        $expectedNames = $functionFiles.BaseName | Sort-Object -Unique

        $exportedNames = (Get-Command -Module DattoRMM -CommandType Function).Name | Sort-Object -Unique

        $expectedNames | Should -Be $exportedNames
    }

    It 'has parseable PowerShell in each function file' {
        $repoRoot = Split-Path -Path $PSScriptRoot -Parent
        $functionFiles = Get-ChildItem -Path (Join-Path -Path $repoRoot -ChildPath 'functions') -Filter '*.ps1' -File

        foreach ($file in $functionFiles) {
            $parseErrors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseFile(
                $file.FullName,
                [ref]$null,
                [ref]$parseErrors
            )

            $parseErrors.Count | Should -Be 0
        }
    }
}

Describe 'Set-DrmmApiParameters' -Tag 'Unit' {
    BeforeEach {
        InModuleScope DattoRMM {
            $script:ApiUrl = $null
            $script:ApiAccessToken = $null
        }
    }

    It 'supports the Connect-DrmmApi alias' {
        InModuleScope DattoRMM {
            (Get-Alias -Name 'Connect-DrmmApi').ReferencedCommand.Name | Should -Be 'Set-DrmmApiParameters'
        }
    }

    It 'sets module variables when Key and SecretKey are provided' {
        InModuleScope DattoRMM {
            Mock -CommandName New-ApiAccessToken -MockWith { 'token-from-key' }

            Set-DrmmApiParameters -Url 'https://merlot-api.centrastage.net' -Key 'key1' -SecretKey 'secret1'

            $script:ApiUrl | Should -Be 'https://merlot-api.centrastage.net'
            $script:ApiAccessToken | Should -Be 'token-from-key'

            Should -Invoke -CommandName New-ApiAccessToken -Exactly 1 -ParameterFilter {
                $Credential.UserName -eq 'key1' -and
                $Credential.GetNetworkCredential().Password -eq 'secret1'
            }
        }
    }

    It 'sets module variables when Credential is provided' {
        InModuleScope DattoRMM {
            Mock -CommandName New-ApiAccessToken -MockWith { 'token-from-credential' }

            $securePassword = ConvertTo-SecureString -String 'secret2' -AsPlainText -Force
            $credential = [pscredential]::new('key2', $securePassword)

            Set-DrmmApiParameters -Url 'https://merlot-api.centrastage.net' -Credential $credential

            $script:ApiUrl | Should -Be 'https://merlot-api.centrastage.net'
            $script:ApiAccessToken | Should -Be 'token-from-credential'

            Should -Invoke -CommandName New-ApiAccessToken -Exactly 1 -ParameterFilter {
                $Credential.UserName -eq 'key2'
            }
        }
    }
}

Describe 'New-ApiAccessToken' -Tag 'Unit' {
    It 'returns an access token from the oauth response' {
        InModuleScope DattoRMM {
            $script:ApiUrl = 'https://merlot-api.centrastage.net'
            $securePassword = ConvertTo-SecureString -String 'my-secret' -AsPlainText -Force
            $credential = [pscredential]::new('my-key', $securePassword)

            Mock -CommandName Invoke-WebRequest -MockWith {
                '{"access_token":"abc123"}'
            }

            $token = New-ApiAccessToken -Credential $credential

            $token | Should -Be 'abc123'
            Should -Invoke -CommandName Invoke-WebRequest -Exactly 1 -ParameterFilter {
                $Uri -eq 'https://merlot-api.centrastage.net/auth/oauth/token' -and
                $Method -eq 'POST' -and
                $Body -match 'grant_type=password&username=my-key&password=my-secret'
            }
        }
    }

    It 'returns nothing when api url is missing' {
        InModuleScope DattoRMM {
            $script:ApiUrl = $null
            $securePassword = ConvertTo-SecureString -String 'api-secret' -AsPlainText -Force
            $credential = [pscredential]::new('api-user', $securePassword)

            Mock -CommandName Invoke-WebRequest -MockWith { '{"access_token":"unused"}' }

            $token = New-ApiAccessToken -Credential $credential

            $token | Should -BeNullOrEmpty
            Should -Invoke -CommandName Invoke-WebRequest -Exactly 0
        }
    }
}

Describe 'New-ApiRequest' -Tag 'Unit' {
    BeforeEach {
        InModuleScope DattoRMM {
            $script:ApiUrl = 'https://merlot-api.centrastage.net'
            $script:ApiAccessToken = 'token-xyz'
        }
    }

    It 'returns UTF8 response content for successful requests' {
        InModuleScope DattoRMM {
            Mock -CommandName Invoke-WebRequest -MockWith {
                $content = '{"status":"ok"}'
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                $stream = [System.IO.MemoryStream]::new()
                $stream.Write($bytes, 0, $bytes.Length)
                $stream.Position = 0
                [pscustomobject]@{ RawContentStream = $stream }
            }

            $result = New-ApiRequest -apiMethod 'GET' -apiRequest '/v2/account/'

            $result | Should -Be '{"status":"ok"}'
            Should -Invoke -CommandName Invoke-WebRequest -Exactly 1 -ParameterFilter {
                $Uri -eq 'https://merlot-api.centrastage.net/api/v2/account/' -and
                $Method -eq 'GET' -and
                $Headers.Authorization -eq 'Bearer token-xyz'
            }
        }
    }

    It 'sends the request body as UTF8 bytes when body is supplied' {
        InModuleScope DattoRMM {
            Mock -CommandName Invoke-WebRequest -MockWith {
                $content = '{"status":"updated"}'
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                $stream = [System.IO.MemoryStream]::new()
                $stream.Write($bytes, 0, $bytes.Length)
                $stream.Position = 0
                [pscustomobject]@{ RawContentStream = $stream }
            }

            $null = New-ApiRequest -apiMethod 'POST' -apiRequest '/v2/device/abc/udf' -apiRequestBody '{"udf1":"Value"}'

            Should -Invoke -CommandName Invoke-WebRequest -Exactly 1 -ParameterFilter {
                $Method -eq 'POST' -and
                $Body -is [byte[]] -and
                [System.Text.Encoding]::UTF8.GetString($Body) -eq '{"udf1":"Value"}'
            }
        }
    }

    It 'retries once after a 429 response and then succeeds' {
        InModuleScope DattoRMM {
            $script:invokeCallCount = 0
            Mock -CommandName Start-Sleep -MockWith { }
            Mock -CommandName Invoke-WebRequest -MockWith {
                $script:invokeCallCount++
                if ($script:invokeCallCount -eq 1) {
                    throw [System.Exception]::new('The remote server returned an error: (429).')
                }

                $content = '{"status":"ok-after-retry"}'
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                $stream = [System.IO.MemoryStream]::new()
                $stream.Write($bytes, 0, $bytes.Length)
                $stream.Position = 0
                [pscustomobject]@{ RawContentStream = $stream }
            }

            $result = New-ApiRequest -apiMethod 'GET' -apiRequest '/v2/account/'

            $result | Should -Be '{"status":"ok-after-retry"}'
            Should -Invoke -CommandName Start-Sleep -Exactly 1 -ParameterFilter { $Seconds -eq 60 }
            Should -Invoke -CommandName Invoke-WebRequest -Exactly 2
        }
    }

    It 'returns nothing when module API parameters are not set' {
        InModuleScope DattoRMM {
            $script:ApiUrl = $null
            $script:ApiAccessToken = $null

            Mock -CommandName Invoke-WebRequest -MockWith {
                $content = '{"status":"should-not-run"}'
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                $stream = [System.IO.MemoryStream]::new()
                $stream.Write($bytes, 0, $bytes.Length)
                $stream.Position = 0
                [pscustomobject]@{ RawContentStream = $stream }
            }

            $result = New-ApiRequest -apiMethod 'GET' -apiRequest '/v2/account/'

            $result | Should -BeNullOrEmpty
            Should -Invoke -CommandName Invoke-WebRequest -Exactly 0
        }
    }
}

Describe 'Set-DrmmDeviceUdf' -Tag 'Unit' {
    It 'sends only provided UDF keys and converts empty string values to null' {
        InModuleScope DattoRMM {
            Mock -CommandName New-ApiRequest -MockWith {
                param($apiMethod, $apiRequest, $apiRequestBody)
                [pscustomobject]@{
                    Method = $apiMethod
                    Path = $apiRequest
                    Body = $apiRequestBody
                }
            }

            $result = Set-DrmmDeviceUdf -DeviceUid 'device-1' -UdfData @{ udf1 = 'Server'; udf300 = '' }
            $body = $result.Body | ConvertFrom-Json

            $result.Method | Should -Be 'POST'
            $result.Path | Should -Be '/v2/device/device-1/udf'
            $body.udf1 | Should -Be 'Server'
            $body.PSObject.Properties.Name | Should -Contain 'udf300'
            $body.udf300 | Should -BeNullOrEmpty

            Should -Invoke -CommandName New-ApiRequest -Exactly 1
        }
    }

    It 'accepts object input for UdfData' {
        InModuleScope DattoRMM {
            Mock -CommandName New-ApiRequest -MockWith {
                param($apiMethod, $apiRequest, $apiRequestBody)
                $apiRequestBody
            }

            $udfObject = [pscustomobject]@{
                udf2 = 'Desktop'
            }

            $jsonBody = Set-DrmmDeviceUdf -DeviceUid 'device-2' -UdfData $udfObject
            $body = $jsonBody | ConvertFrom-Json

            $body.udf2 | Should -Be 'Desktop'
        }
    }

    It 'throws when UdfData contains an invalid key' {
        InModuleScope DattoRMM {
            { Set-DrmmDeviceUdf -DeviceUid 'device-1' -UdfData @{ field1 = 'Invalid' } } | Should -Throw 'Invalid UDF key*'
        }
    }

    It 'throws when UdfData has no values to process' {
        InModuleScope DattoRMM {
            { Set-DrmmDeviceUdf -DeviceUid 'device-1' -UdfData @{} } | Should -Throw 'No UDF values were provided*'
        }
    }

    It 'does not call New-ApiRequest when -WhatIf is used' {
        InModuleScope DattoRMM {
            Mock -CommandName New-ApiRequest -MockWith { 'should-not-run' }

            $null = Set-DrmmDeviceUdf -DeviceUid 'device-3' -UdfData @{ udf10 = 'Value' } -WhatIf

            Should -Invoke -CommandName New-ApiRequest -Exactly 0
        }
    }
}
