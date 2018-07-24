package org.south.itms.util;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

/**
 * @author jan
 * @date 2018年1月17日 下午4:10:22
 * @version V1.0 
 */
public class UploadCommonsMultipartResolver extends CommonsMultipartResolver {
	protected MultipartParsingResult parseRequest(HttpServletRequest request)
            throws MultipartException {
        HttpSession session = request.getSession();
        String encoding = "utf-8";
        FileUpload fileUpload = prepareFileUpload(encoding);
        System.out.println("wolaiguo");
        FileUploadListener uploadListener = new FileUploadListener(session);
        fileUpload.setProgressListener(uploadListener);
        //System.out.println("111111");
        //System.out.println("percent=" + (UploadState)session.getAttribute("uploadState"));

        try {
            List<FileItem> fileItem = ((ServletFileUpload)fileUpload).parseRequest(request);
            return parseFileItems(fileItem, encoding);
        } catch (FileUploadBase.SizeLimitExceededException ex) {
            // TODO Auto-generated catch block
            throw new MaxUploadSizeExceededException(fileUpload.getSizeMax(), ex);
        }catch (FileUploadException ex) {
            // TODO: handle exception
            throw new MultipartException("Could not parse multipart servlet request",ex);
        }
    }
}
