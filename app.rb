require 'sinatra'
require 'liquid'


# START SINATRA SETTINGS
set :root, File.dirname(__FILE__)
enable  :sessions
if File.exist? 'start' # if the launch file exists
	set :environment, :production # launch with production settings
end
# END SINATRA SETTINGS


class TemplateCache
	# template cache system

	def initialize
		@templates = {}
		@mtimes = {}
		@debug = false
	end
	
	def debug
		@debug = true
	end

	def get(tname)
		internal(tname) {|i|;return i}
	end

	private
	def internal(tname)
		#begin
		if @debug
			p "debug:templates::#{@templates}"
			p "debug:mtimes::#{@mtimes}"
			p ""
		end
		#rescue
		#	p 'debug error.'
		#end
		if @templates.has_key? tname
			yield @templates[tname]
		else
			begin
				@mtimes[tname] = File.mtime("./#{tname}.liquid")
				@templates[tname] = open("./#{tname}.liquid").read()
				yield @templates[tname]
			rescue Exception => er
				p "Exception::#{er}"
				yield "Woops, hey there, looks like something went wrong here... :/"
			end
		end
		update(tname)
	end

	def update(tname)
		begin
			if File.mtime(@templates[tname]) != @mtimes[tname]
				p "updated #{tname}!"
				@mtimes[tname]=File.mtime("./#{tname}.liquid")
			end
		rescue
			''
		end
	end
end

tc = TemplateCache.new
tc.debug

get '/' do
	begin
		Liquid::Template.parse( tc.get("index") ).render(  )
	rescue
		Liquid::Template.parse( tc.get("index") ).render(  )
	end
end

get '/favicon.ico' do
	''
end

get '/*' do
	p 'tc.get::'+tc.get("index")
	p "params::#{params}"
	begin
		#p "#{params[:splat][0].split('/')}"
		Liquid::Template.parse( tc.get("#{params[:splat][0].split('/')[0]}") ).render( 'params' => params[:splat][0].split('/').drop(1) )
	rescue
		Liquid::Template.parse( tc.get("#{params[:splat][0]}") ).render( 'params' => "#{params[:splat][0].downcase.capitalize}" )
	end
end
