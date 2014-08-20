#!/usr/bin/ruby
require 'socket'
require 'thwait'


#
# Test function
#
def test
  t = WomClient.new :t
  u = WomClient.new :u

  tt =  Thread.new do
      print "t:::", t.recommendContentExternal(5, 20); puts
      print "t:::", t.recommendContentExternal(5, 20); puts
      print "t:::", t.recommendContentExternal(5, 20); puts
      print "t:::", t.recommendContentExternal(15, 20); puts
  end

  uu = Thread.new do
      print "u:::", u.recommendContentExternal(5, 20); puts
      print "u:::", u.recommendContentExternal(5, 20); puts
      print "u:::", u.recommendContentExternal(5, 20); puts
      print "u:::", u.recommendContentExternal(15, 20); puts
  end

  # Wait for both threads to finish
  tt.join
  uu.join
end



#
# Client to access the WoM backend server
#
class WomClient
  # Global variables
  ServerExternal = "54.69.23.25"
  ServerInternal = "172.31.34.32"
  Port = 2014

  def initialize *args
    # Instance variables
    @sock = nil
    @id   = args[0]
  end

  def _openSocket(server, port)
    begin
      puts ("#{@id}:: Connecting to WoM backend...")
      @sock = TCPSocket.open(server, port)
    rescue
      # Do nothign if socket connection attempt fails.
      @sock = nil
    end
    puts "#{@id}:: sock=#{@sock}"
  end

  #
  # Cook uid and count arguments. Should be integers so convert strings into integers.
  # Assume a non-integer count is "no argument" so default to 10
  #
  def _normalizeUidCount (uid, count)
    if String == uid.class; uid = uid.to_i end
    if Fixnum != count.class
      count = count.to_i
      if 0 == count; count = 10 end
    end
    [uid, count]
  end

  #
  # Perform the actual query to the remote WoM backend.
  #
  def _recommendContent (server, port, uid, count)
    ret = [1,2,3,4,5,6,7,8,9,10] # TODO: Temporary default content array

    # normalize args
    uid, count = _normalizeUidCount(uid, count)

    # If socket closed or invalid, try and reconnect
    if @sock == nil || @sock.closed?
      _openSocket(server, port)
    end

    # Still no socket or a count of 0, so give them an empty list.
    if @sock == nil || 0 == count; return [] end 

    begin
      # Send request
      puts "#{@id}:: Sending #{uid} #{count}..."
      @sock.print("#{uid} #{count}\n")
      # Receive response
      puts "#{@id}:: Receiving..."
      str = @sock.gets
      # Parse/deserialize the response into a ruby object
      ret = eval(str)
    rescue
      # Do nothing on error or exception.  We'll just return the default content.
      puts "#{@id}:: Closing socket..."
      @sock.close
    end

    return ret
  end

  # Call when inside the AWS network
  def recommendContent (uid, count=10)
    _recommendContent(ServerInternal, Port, uid, count) 
  end

  # Call when outside the AWS network
  def recommendContentExternal (uid, count=10)
    _recommendContent(ServerExternal, Port, uid, count) 
  end

end # class WomClient
