
### Get this product for $5

<i>Packt is having its biggest sale of the year. Get this eBook or any other book, video, or course that you like just for $5 each</i>


<b><p align='center'>[Buy now](https://packt.link/9781788625241)</p></b>


<b><p align='center'>[Buy similar titles for just $5](https://subscription.packtpub.com/search)</p></b>


# Hands-On Full-Stack Development with Swift
This is the code repository for [Hands-On Full-Stack Development with Swift](https://www.packtpub.com/web-development/hands-full-stack-development-swift?utm_source=github&utm_medium=repository&utm_campaign=9781788625241), authored by [Ankur Patel](https://github.com/ankurp), published by [Packt](https://www.packtpub.com/?utm_source=github). It contains all the supporting project files necessary to work through the book from start to finish.

## About the Book
Making Swift an open-source language enabled it to share code between a native app and a server. Building a scalable and secure server backend opens up new possibilities, such as building an entire application written in one language—Swift.

This book gives you a detailed walk-through of tasks such as developing a native shopping list app with Swift and creating a full-stack backend using Vapor (which serves as an API server for the mobile app). You'll also discover how to build a web server to support dynamic web pages in browsers, thereby creating a rich application experience.

You’ll begin by planning and then building a native iOS app using Swift. Then, you'll get to grips with building web pages and creating web views of your native app using Vapor. To put things into perspective, you'll learn how to build an entire full-stack web application and an API server for your native mobile app, followed by learning how to deploy the app to the cloud, and add registration and authentication to it.

Once you get acquainted with creating applications, you'll build a tvOS version of the shopping list app and explore how easy is it to create an app for a different platform with maximum code shareability. Towards the end, you’ll also learn how to create an entire app for different platforms in Swift, thus enhancing your productivity.

## Instructions and Navigation
All of the code is organized into folders. Each folder starts with a number followed by the application name. For example, Chapter02.

The code will look like the following:

```swift
@IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
  requestInput(title: "Shopping list name",
    message: "Enter name for the new shopping list:",
    handler: { listName in
      let listCount = self.lists.count
      ShoppingList(name: listName).save() { list in
        self.lists.append(list)
        self.tableView.insertRows(at: [IndexPath(row: listCount, 
        section: 0)], with: .top)
      }
    })
}
```

You should have basic knowledge of the following topics:

* Swift
* Xcode
* Storyboard and Autolayout
* HTML
* JavaScript
* CSS
* Terminal/Command Line Tools

You should also use `macOS` as we will be using Xcode to build our native apps and our server app.

## Related Products
* [Hands-on Full Stack Development with Angular 5 and Firebase](https://www.packtpub.com/application-development/hands-full-stack-development-angular-5-and-firebase?utm_source=github&utm_medium=repository&utm_campaign=9781788298735)

* [Mastering Swift 4 - Fourth Edition](https://www.packtpub.com/application-development/mastering-swift-4-fourth-edition?utm_source=github&utm_medium=repository&utm_campaign=9781788477802)

* [Reactive Programming with Swift 4](https://www.packtpub.com/application-development/reactive-programming-swift-4?utm_source=github&utm_medium=repository&utm_campaign=9781787120211)

![Book Cover](https://www.packtpub.com/sites/default/files/B09073_0.png)
### Download a free PDF

 <i>If you have already purchased a print or Kindle version of this book, you can get a DRM-free PDF version at no cost.<br>Simply click on the link to claim your free PDF.</i>
<p align="center"> <a href="https://packt.link/free-ebook/9781788625241">https://packt.link/free-ebook/9781788625241 </a> </p>