namespace Calc.Tests;

public class MathsFacts
{
    [Fact]
    public void AddWorks() => Assert.Equal(3, Maths.Add(1, 2));

    [Fact]
    public void MulWorks() => Assert.Equal(6, Maths.Mul(2, 3));
}
