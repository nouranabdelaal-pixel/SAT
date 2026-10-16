using Microsoft.AspNetCore.Mvc.Testing;

namespace Api.Tests;

public class ApiFacts(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    [Fact]
    public async Task RootSaysHello()
    {
        var client = factory.CreateClient();
        Assert.Equal("Hello World!", await client.GetStringAsync("/"));
    }

    [Fact]
    public async Task AddAdds()
    {
        var client = factory.CreateClient();
        Assert.Equal("3", await client.GetStringAsync("/add/1/2"));
    }
}
