package org.south.netty;

import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.serialization.ClassResolvers;
import io.netty.handler.codec.serialization.ObjectDecoder;
import io.netty.handler.codec.serialization.ObjectEncoder;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import io.netty.handler.timeout.IdleStateHandler;

/**
 * @author: yezilong
 */

public class NettyServer implements ServletContextListener {  //用于tomcat启动时，启动netty服务器

	
	private Thread myThread;
	private Thread playThread;
	
	
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		myThread = new Thread(new Runnable() {    //使用另一个线程来执行该方法，会避免占用Tomcat的启动时间 

			@Override
			public void run() {
				startNettyServer();    //启动netty服务器
			}
			
		});
		
		myThread.start();
		
		playThread = new Thread(new Runnable() {
			
			public void run() {
				//new TableGenerate();
				//new FileToServer();
			}
		});
		
		//playThread.start();
		
	}
	
	

	private final int PORT = Integer.parseInt(System.getProperty("port", "8007"));
	
	private final AcceptorIdleStateTrigger idleStateTrigger = new AcceptorIdleStateTrigger();  
	
	
	private void startNettyServer() {    //启动netty服务器
		EventLoopGroup bossGroup = new NioEventLoopGroup(1);
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
             .channel(NioServerSocketChannel.class)
             .handler(new LoggingHandler(LogLevel.INFO))
             .childHandler(new ChannelInitializer<SocketChannel>() {
                @Override
                public void initChannel(SocketChannel ch) throws Exception {
                    ChannelPipeline p = ch.pipeline();
                    p.addLast(new IdleStateHandler(65, 0, 0, TimeUnit.SECONDS));  //连接上来 的客户端10秒内，没有响应就检查是否是空连接 
                    p.addLast(idleStateTrigger);  
                    
                    p.addLast(
                            new ObjectEncoder(),
                            new ObjectDecoder(Integer.MAX_VALUE, ClassResolvers.cacheDisabled(null)),
                            new NettyServerHandler());
                }
             }).option(ChannelOption.SO_BACKLOG, 128).childOption(ChannelOption.SO_KEEPALIVE, true);

            // Bind and start to accept incoming connections.
            b.bind(PORT).sync().channel().closeFuture().sync();
        } catch(Exception e) {
        	e.printStackTrace();
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
        
        System.out.println("close ObjectEchoServer");
	}


	@Override
	public void contextDestroyed(ServletContextEvent arg0) {   //关闭时回收资源
		// TODO Auto-generated method stub
		try {
			myThread.interrupt();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
