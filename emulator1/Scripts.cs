using System;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Fluent;
using System.Threading.Tasks;
using System.Threading;

namespace Something
{
    public class LogHandler : RequestHandler
    {
        public override async Task<ResponseMessage> SendAsync(
            RequestMessage request,
            CancellationToken cancellationToken
        )
        {
            Console.WriteLine($"[{request.Method.Method}]\t{request.RequestUri}");
            ResponseMessage response = await base.SendAsync(request, cancellationToken);
            Console.WriteLine($"[{Convert.ToInt32(response.StatusCode)}]\t{response.StatusCode}");
            return response;
        }
    }

    public class Program
    {
        public static async Task Main(string[] args)
        {
            string connectionString =
                "AccountEndpoint=https://localhost:8081/;AccountKey=C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==";
            CosmosClientBuilder builder = new(connectionString);
            builder.AddCustomHandlers(new LogHandler());
            CosmosClient client = builder.Build();
            Database database = await client.CreateDatabaseIfNotExistsAsync("cosmicworks");
            Console.WriteLine($"New Database:\tId: {database.Id}");
            Container container = await database.CreateContainerIfNotExistsAsync(
                "products",
                "/categoryId",
                400
            );
            Console.WriteLine($"New Container:\tId: {container.Id}");
        }
    }
}