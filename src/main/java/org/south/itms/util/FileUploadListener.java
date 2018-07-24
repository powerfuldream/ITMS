package org.south.itms.util;

import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.ProgressListener;
import org.south.itms.util.UploadState;
/**
 * @author jan
 * @date 2018年1月17日 下午3:46:37
 * @version V1.0 
 */
public class FileUploadListener implements ProgressListener {
	
	private HttpSession session;
    public FileUploadListener(HttpSession session){
        super();
        this.session = session;
        UploadState uploadState = new UploadState();
        System.out.println("daociyiyou");
        session.setAttribute("uploadState", uploadState);
        //System.out.println("daociliangyou");
    }

	@Override
	public void update(long uploadByte, long fileSizeByte, int fileIndex) {
		if (fileSizeByte == -1) {
		      // 如果上传的大小为-1则上传已经完成
		      System.out.println("上传文件结束！");
		    } else {
		      if (session.getAttribute("uploadState") == null) {
		    	//System.out.println("kongkong88888");
		        // 如果为空就new一个State对象并设置里面的文本内容
		        UploadState state = new UploadState();
		        state.setState(uploadByte, fileSizeByte, (fileIndex - 1));
		        //System.out.println("-----" + state.getPercent());
		        session.setAttribute("uploadState", state);
		      } else {
		    	//System.out.println("bubukong88888");
		        // 如果session中有uploadState对象就取出来，然后设置里面文本内容
		        UploadState state = (UploadState) session.getAttribute("uploadState");
		        state.setState(uploadByte, fileSizeByte, (fileIndex - 1));
		        //System.out.println("====" + state.getPercent());
		      }
		    }
	}

}
