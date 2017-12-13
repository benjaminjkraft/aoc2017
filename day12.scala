import scala.io.StdIn
import scala.collection.mutable.Map
import scala.collection.immutable.Set

object Main {
  def componentSizes(graph: Map[Int, Array[Int]]): Map[Int, Int] = {
    var seen = Set[Int]()
    val sizes = Map[Int, Int]()
    for ((start, _) <- graph) {
      if (!seen.contains(start)) {
        var queue = List(start)
        var component = Set[Int]()
        while (queue.nonEmpty) {
          var it = queue.head
          queue = queue.tail
          if (!seen.contains(it)) {
            queue ++= graph(it).toList
            seen += it
            component += it
          }
        }
        sizes(component.min) = component.size
      }
    }
    return sizes
  }

  def main(args: Array[String]): Unit = {
    val graph = Map[Int, Array[Int]]()
    var line = StdIn.readLine()
    while (line != null && line.nonEmpty) {
      val words = line.split(' ')
      graph(words(0).toInt) = words.slice(
        2, words.length).map(_.stripSuffix(",").toInt)
      line = StdIn.readLine()
    }
    val sizes = componentSizes(graph)
    println(sizes(0).toString)
    println(sizes.size.toString)
  }
}
