require 'sinatra'
require 'liquid'

# START SINATRA SETTINGS
#set :root, File.dirname(__FILE__)
# END SINATRA SETTINGS

class TemplateCache
	# template cache system
	def initialize
		@templates = {}
		@mtimes = {}
	end
	def get(tname)
		p @templates
		p @mtimes
		if @templates[tname] != nil
			return @templates[tname]
		else
			begin
				@templates[tname]=open("./#{tname}.liquid").read()
				@mtimes[tname]=File.mtime("./#{tname}.liquid")
			rescue
				"Woops, hey there, looks like something went wrong here... :/"
			end
		end
		update(tname)
	end
	private
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
	p 'tc.get'+tc.get("index")
	#liquid :page, :locals => { :key => 'value' }
	p "params#{params}"
	begin
		p "#{params[:splat][0].split('/')}"
		Liquid::Template.parse( tc.get("#{params[:splat][0].split('/')[0]}") ).render( 'params' => params[:splat][0].split('/').drop(1) )
	rescue
		Liquid::Template.parse( tc.get("#{params[:splat][0]}") ).render( 'params' => "#{params[:splat][0].downcase.capitalize}" )
	end
end