import FileReader

for argument in CommandLine.arguments {
  guard argument != "arg1" else {
    continue
  }

  if let fileContents = FileReader.read(fileName: argument) {
    print(fileContents)
  }
}
