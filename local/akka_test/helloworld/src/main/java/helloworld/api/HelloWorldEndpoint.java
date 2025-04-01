package helloworld.api;

import akka.javasdk.annotations.Acl;
import akka.javasdk.annotations.http.HttpEndpoint;
import akka.javasdk.annotations.http.Get;
import akka.javasdk.annotations.http.Post;

import java.util.concurrent.CompletionStage;
import static java.util.concurrent.CompletableFuture.completedStage;

/**
 * This is a simple Akka Endpoint that returns "Hello World!".
 * Locally, you can access it by running `curl http://localhost:9000/hello`.
 */
// Opened up for access from the public internet to make the service easy to try out.
// For actual services meant for production this must be carefully considered, and often set more limited
@Acl(allow = @Acl.Matcher(principal = Acl.Principal.INTERNET))
@HttpEndpoint("/hello")
public class HelloWorldEndpoint {

  @Get("/")
  public CompletionStage<String> helloWorld() {
    return completedStage("Hello World!");
  }

  @Get("/hello/{name}")
  public String hello(String name) {
    return "Hello " + name;
  }

  @Get("/hello/{name}/{age}")
  public String hello(String name, int age) {
    return "Hello " + name + "! You are " + age + " years old";
  }

  public record GreetingRequest(String name, int age) {}

  @Post("/hello")
  public String hello(GreetingRequest greetingRequest) {
    return "Hello " + greetingRequest.name + "! " +
      "You are " + greetingRequest.age + " years old";
  }

  @Post("/hello/{number}")
  public String hello(int number, GreetingRequest greetingRequest) {
    return number + " Hello " + greetingRequest.name + "! " +
      "You are " + greetingRequest.age + " years old";
  }
  
  public record MyResponse(String name, int age) {}

  @Get("/hello-response/{name}/{age}")
  public MyResponse helloJson(String name, int age) {
    return new MyResponse(name, age);
  }
}
