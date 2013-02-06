module.exports = ()=>
	generateToken: ()=>
		uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx-xxx-xx-xxxxxxxxxx'.replace(/[xy]/g, (c) ->
		    r = Math.random() * 16 | 0
		    v = if c is 'x' then r else (r & 0x3|0x8)
		    v.toString(16)
		  )
		return uuid