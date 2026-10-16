namespace App;

public class MathsFacts
{
    [Fact]
    public void AddWorks() => Assert.Equal(3, Maths.Add(1, 2));
}
