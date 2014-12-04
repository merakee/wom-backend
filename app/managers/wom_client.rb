#
# Client to access the WoM backend server.  The WoM backend will try to connect to a frontend server but leaves a port open for direct testing.
#
class WomClient
  DEFAULT_SERVER = ENV["RECOM_ENGINE_SERVER"] || "localhost" #"recommendsvd.freelogue.net"
  DEFAULT_PORT   = 2014

  def initialize (_server=nil, _port=nil)
    # Instance variables
    @server = (_server ? _server : DEFAULT_SERVER)
    @port   = (_port   ? _port   : DEFAULT_PORT)
    @sock = nil
  end

  def _openSocket(server, port)
    #puts "::_openSocket";
    begin
      @sock = TCPSocket.open(server, port)
    rescue
      # Do nothign if socket connection attempt fails.
      @sock = nil
      return
    end
    # Verify HELO message
    ret = @sock.gets
    if ret != "# RECOMMENDER SVD\n"; puts "ERROR: SVD recommendation server did not send a valid initial greeting.  Received '#{ret}'" end
  end

  def _close
    @sock.close
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
    ret = [] # Empty content returned if an exception occurs.

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
      @sock.print("#{uid} #{count}\n")
      # Receive response
      str = @sock.gets
      # Parse/deserialize the response into a ruby object
      ret = eval(str)
    rescue
      # Do nothing on error or exception.  We'll just return the default content.
      @sock.close
    end

    return ret
  end

  # Call when inside the AWS network
  def recommendContent (uid, count=10)
    _recommendContent(@server, @port, uid, count) 
  end

end # class WomClient
