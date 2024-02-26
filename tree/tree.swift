//
//  main.swift
//  tree
//
//  Created by Eric Hemmeter on 2/23/24.
//

import Foundation
import ArgumentParser
import FileSystemTree

@main
struct Tree: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
    commandName: "tree",
    abstract: "Builds a tree of a directory's files and all subdirectores and files.  Can output in text, json, and html."
    )
    @Flag(name: .shortAndLong, help: "Output JSON") var json = false
    @Flag(name: .shortAndLong, help: "Output HTML") var html = false
    @Flag(name: .shortAndLong, help: "Include hidden files") var showHiddenFiles = false
    @Argument(help: "The full path to the directory that will be root level for the tree.") var rootDir: String
    
    mutating func validate() throws {
        var isDir: ObjCBool = true
        guard rootDir != "" && FileManager.default.fileExists(atPath: rootDir, isDirectory: &isDir) else {
            throw ValidationError("Please provide the path to the root directory.")
        }
    }
    
    mutating func run() async throws {
        let fileSystemTree = FileSystemTree()
        let rootURL = URL(filePath: rootDir)
        var passedOutput: String
        if json {
            passedOutput = "json"
        } else if html {
            passedOutput = "html"
        } else {
            passedOutput = "text"
        }
        var displayOutput: ([String], Int, Int)
        switch passedOutput {
        case "text":
            displayOutput = try fileSystemTree.getContentsText(directory: rootURL, prefix: "", showHiddenFiles: showHiddenFiles)
            print(displayOutput.0.joined(separator: "\n"))
            print("Directory Count: \(displayOutput.1), File Count: \(displayOutput.2)")
            
        case "json":
            print(
                """
                    [
                    {\"type\":\"directory\",\"name\":\"\(rootURL.path)\",\"contents\":[
                """
            )
            let entries = await fileSystemTree.getArray(sourceURL: rootURL, showHiddenFiles: showHiddenFiles)
            displayOutput = try fileSystemTree.getContentsJSON(entryArray: entries, parentFolderURL: rootURL, showHiddenFiles: showHiddenFiles)
            print(displayOutput.0.joined(separator: "\n"))
//            print("Directory Count: \(displayOutput.1), File Count: \(displayOutput.2)")
            print("""
                ]}
                ]
                """)
            
        case "html":
            print(
                """
                <!DOCTYPE html>
                <html lang="en">
                <head>
                <meta charset="utf-8">
                <title>\(rootURL.path) Info</title>
                </head>
                <body>
                <h2>Directory Tree \(rootURL.path)</h2>
                """
            )
            let entries = await fileSystemTree.getArray(sourceURL: rootURL, showHiddenFiles: showHiddenFiles)
            displayOutput = try fileSystemTree.getContentsHTML(entryArray: entries, parentFolderURL: rootURL, showHiddenFiles: showHiddenFiles)
            print(displayOutput.0.joined(separator: "\n"))
            print("Directory Count: \(displayOutput.1), File Count: \(displayOutput.2)")
            print(
                """
                </body>
                </html>
                """
            )
            
        default:
            displayOutput = (["No type"], 0, 0)
            print("No type matched")
        }
    }
}


