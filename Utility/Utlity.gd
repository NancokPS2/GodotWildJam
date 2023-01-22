extends Node
class_name Utility

class NodeManipulation extends Node:
	
	static func get_all_children(node:Node,typeFilter:String="") -> Array:#Obtiene todos los nodos hijos y nietos en un array
		
		var nodes : Array = []

		for child in node.get_children():

			if child.get_child_count() > 0:
					nodes.append(child)
					nodes.append_array( get_all_children(child) )

			else:
				nodes.append(child)

		return nodes
		
	static func remove_all_children(node:Node):
		for child in node.get_children():
			node.remove_child(child)
	
class FileManipulation extends Node:
	static func get_files_in_folder(path:String) -> Array:#Obtiene todos los archivos en una carpeta
		var returnedFiles:Array
		var loadingDir = Directory.new()
		loadingDir.open(path)#Start loading abilities
		loadingDir.list_dir_begin(true)
		var fileName = loadingDir.get_next()
		
		while fileName != "":
			if !loadingDir.current_is_dir():
				var loadedFile = load(path + fileName)
				returnedFiles.append(loadedFile)
				
			fileName = loadingDir.get_next()#Get next file
		return returnedFiles
		
	static func get_file_paths_in_folder(path:String) -> Array:#Obtiene todos los file paths de los archivos en una carpeta
			var returnedPaths:Array
			var loadingDir = Directory.new()
			loadingDir.open(path)#Start loading abilities
			loadingDir.list_dir_begin()
			var fileName = loadingDir.get_next()
			
			while fileName != "":
				if !loadingDir.current_is_dir():
					returnedPaths.append(path+fileName)
					
				fileName = loadingDir.get_next()#Get next file
			return returnedPaths

	static func get_folders_in_folder(path:String)->Array:#Me perdi
			var returnedPaths:Array
			var loadingDir = Directory.new()
			loadingDir.open(path)#Start loading abilities
			loadingDir.list_dir_begin(true)
			var folderName = loadingDir.get_next()
			
			while folderName != "":
				if loadingDir.current_is_dir():
					returnedPaths.append(path+folderName)
					
				folderName = loadingDir.get_next()#Get next file
			return returnedPaths

class VectorManipulation extends Node:
	func clockwise_tangent(vector:Vector2, times:int=1)->Vector2:
		var vec = vector
		for amount in range(times):
			vec = -vec.tangent()
		return vec
		
		
