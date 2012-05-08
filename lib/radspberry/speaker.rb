require 'ffi-portaudio'

module Speaker
  extend self
  def [] *args
    @@stream = AudioStream.new( *args )
    self
  end
  
  def volume= gain
    @@stream.gain = gain
  end

  def volume
    @@stream.gain
  end
  
  def mute
    @@stream.muted = true
  end
  
  def unmute
    @@stream.muted = false
  end
  
  def toggleMute
    @@stream.muted = !@@stream.muted
  end

end

class AudioStream < FFI::PortAudio::Stream
  include FFI::PortAudio
  attr_accessor :gain, :muted
  
  def initialize gen, frameSize=2**12, gain=1.0  # 1024
    @synth = gen # responds to tick
    @gain  = gain
    raise ArgumentError, "#{synth.class} doesn't respond to ticks!" unless @synth.respond_to?(:ticks)
    init!( frameSize )
    start
  end

  def process input, output, framesPerBuffer, timeInfo, statusFlags, userData
    # inp = input.read_array_of_int16(framesPerBuffer)
    if @muted
      out = Array.zeros( framesPerBuffer )
    else
      if @gain == 1.0
        out = @synth.ticks( framesPerBuffer )
      else
        out = (Vector[ *@synth.ticks( framesPerBuffer ) ] * @gain).to_a
      end
    end
    output.write_array_of_float out
    :paContinue
  end

  def init! frameSize=nil
    API.Pa_Initialize

    # input = API::PaStreamParameters.new
    # input[:device] = API.Pa_GetDefaultInputDevice
    # input[:sampleFormat] = API::Float32
    # input[:suggestedLatency] = API.Pa_GetDeviceInfo( input[:device ])[:defaultLowInputLatency]
    # input[:hostApiSpecificStreamInfo] = nil
    # input[:channelCount] = 1 #2; 

    input = nil
    
    output = API::PaStreamParameters.new
    output[:device]                    = API.Pa_GetDefaultOutputDevice
    output[:suggestedLatency]          = API.Pa_GetDeviceInfo(output[:device])[:defaultHighOutputLatency]
    output[:hostApiSpecificStreamInfo] = nil
    output[:channelCount]              = 1 #2; 
    output[:sampleFormat]              = API::Float32
    p open( input, output, @synth.srate.to_i, frameSize )

    at_exit do
      puts "#{self.class} terminating! closing PortAudio stream..."
      close
      API.Pa_Terminate
      puts "done!"
    end
  end    

end
