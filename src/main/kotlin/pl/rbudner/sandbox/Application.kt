package pl.rbudner.sandbox

class Application {
    fun display(text: String) = println(text)
}

fun main() {
    Application().display("hello world")
    Application().display(Person("Robert").name)
}
