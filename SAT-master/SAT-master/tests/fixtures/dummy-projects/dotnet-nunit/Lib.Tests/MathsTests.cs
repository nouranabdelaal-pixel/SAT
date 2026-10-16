namespace Lib.Tests;

[TestFixture]
public class MathsTests
{
    [Test]
    public void AddWorks() => Assert.That(Maths.Add(1, 2), Is.EqualTo(3));
}
