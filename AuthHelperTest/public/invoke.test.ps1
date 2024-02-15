function AuthHelperTest_Invoke_Success{
	Set-InvokeCommandAlias -Alias ListFiles -Command "dir" -Tag AuthHelper_Test

	Set-InvokeCommandMock -Alias "dir" -Command "echo 'test'"

	$result = Invoke-MyCommand -Command "dir"

	Assert-AreEqual -Expected "test" -Presented $result
}
