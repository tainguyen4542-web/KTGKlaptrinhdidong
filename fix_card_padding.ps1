$path = "d:\doan\ktra\frontend\lib\screens\admin_import_screen.dart"
$c = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Replace the 4 occurrences of invalid Card padding
$c = $c.Replace("      padding: const EdgeInsets.all(24),`r`n      child: Column(", "      child: Padding(`r`n        padding: const EdgeInsets.all(24),`r`n        child: Column(")
$c = $c.Replace("      padding: const EdgeInsets.all(24),`n      child: Column(", "      child: Padding(`n        padding: const EdgeInsets.all(24),`n        child: Column(")

# Add closing parenthesis for Padding before the closing Card paren
# In each method: _buildExamDocumentCard, _buildExamDetailsCard, _buildReadyForReviewCard, _buildActivateSessionCard
# Each ends with: "    );\r\n  }\r\n"
$c = $c.Replace("        ],`r`n      ),`r`n    );`r`n  }`r`n`r`n  Widget _buildExamDetailsCard", "        ],`r`n      ),`r`n      ),`r`n    );`r`n  }`r`n`r`n  Widget _buildExamDetailsCard")
$c = $c.Replace("        ],`n      ),`n    );`n  }`n`n  Widget _buildExamDetailsCard", "        ],`n      ),`n      ),`n    );`n  }`n`n  Widget _buildExamDetailsCard")

$c = $c.Replace("        ],`r`n      ),`r`n    );`r`n  }`r`n`r`n  Widget _buildReadyForReviewCard", "        ],`r`n      ),`r`n      ),`r`n    );`r`n  }`r`n`r`n  Widget _buildReadyForReviewCard")
$c = $c.Replace("        ],`n      ),`n    );`n  }`n`n  Widget _buildReadyForReviewCard", "        ],`n      ),`n      ),`n    );`n  }`n`n  Widget _buildReadyForReviewCard")

$c = $c.Replace("        ],`r`n      ),`r`n    );`r`n  }`r`n`r`n  Widget _buildBreakdownRow", "        ],`r`n      ),`r`n      ),`r`n    );`r`n  }`r`n`r`n  Widget _buildBreakdownRow")
$c = $c.Replace("        ],`n      ),`n    );`n  }`n`n  Widget _buildBreakdownRow", "        ],`n      ),`n      ),`n    );`n  }`n`n  Widget _buildBreakdownRow")

$c = $c.Replace("        ],`r`n      ),`r`n    );`r`n  }`r`n}", "        ],`r`n      ),`r`n      ),`r`n    );`r`n  }`r`n}")
$c = $c.Replace("        ],`n      ),`n    );`n  }`n}", "        ],`n      ),`n      ),`n    );`n  }`n}")

[System.IO.File]::WriteAllText($path, $c, [System.Text.Encoding]::UTF8)
Write-Output "Fixed Card padding in $path"
