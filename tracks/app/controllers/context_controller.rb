class ContextController < ApplicationController
  
    
  helper :context
  model :project
  before_filter :login_required
  # caches_action :list, :show
  
  layout "standard"
  
  
  # Main method for listing contexts
	# Set page title, and collect existing contexts in @contexts
	#
  def list
		@page_title = "List Contexts"
		@contexts = Context.find_all
	end
	
	
	# Called by a form button
	# Parameters from form fields should be passed to create new context
	#
	def add_context
		context = Context.new
		context.attributes = @params["new_context"]

			if context.save
			  flash["confirmation"] = "Succesfully created context"
				redirect_to( :action => "list" )
			else
				flash["warning"] = "Couldn't add new context"
				redirect_to( :action => "list" )
			end
	end
	
	
	def edit
	  @context = Context.find(@params['id'])
    @page_title = "Edit context: #{@context.name.capitalize}"  
	end
	
	
	def update
    @context = Context.find(@params['context']['id'])
    @context.attributes = @params['context']
    if @context.save
      flash["confirmation"] = 'Context was successfully updated'
      redirect_to :action => 'list'
    else
      flash["warning"] = 'Context could not be updated'
      redirect_to :action => 'list'
    end
  end
  

	# Filter the contexts to show just the one passed in the URL
  # e.g. <home>/context/show/<context_id> shows just <context_id>.
  #
	def show
	  @context = Context.find(@params["id"])
	  @projects = Project.find_all
	  @page_title = "Context: #{@context.name.capitalize}"
	  @not_done = Todo.find_all( "context_id=#{@context.id} AND done=0", "created ASC" )
	  @count = Todo.count( "context_id=#{@context.id} AND done=0" )
  end
  
  
  # Called by a form button
	# Parameters from form fields are passed to create new action
	# in the selected context.
  def add_item
		item = Todo.new
		item.attributes = @params["new_item"]
		
		back_to = item.context_id
   
     if item.save
       flash["confirmation"] = "Succesfully added action to context"
       redirect_to( :controller => "context", :action => "show", :id => "#{back_to}" )
     else
       flash["warning"] = "Could not add action to context"
       redirect_to( :controller => "context", :action => "show", :id => "#{back_to}" )
     end
	end
	
	
	# Fairly self-explanatory; deletes the context
	# If the context contains actions, you'll get a warning dialogue.
	# If you choose to go ahead, any actions in the context will also be deleted.
	def destroy
	  context = Context.find(@params['id'])
		if context.destroy
			flash["confirmation"] = "Succesfully deleted context"
			redirect_to( :action => "list" )
		else
			flash["warning"] = "Couldn't delete context"
			redirect_to( :action => "list" )
		end
	end
	
	
end