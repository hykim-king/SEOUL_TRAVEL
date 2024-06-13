package com.pcwk.ehr.travel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.pcwk.ehr.cmn.ConnectionMaker;
import com.pcwk.ehr.cmn.DBUtill;
import com.pcwk.ehr.cmn.DTO;
import com.pcwk.ehr.cmn.PLog;
import com.pcwk.ehr.cmn.WorkDiv;

public class ReviewDAO implements WorkDiv<ReviewDTO>, PLog {
    private ConnectionMaker connectionMaker;

    public ReviewDAO() {
        connectionMaker = new ConnectionMaker();
    }
    
    /**
     * 리뷰 삽입
     * @param param
     * @return 성공(1) 실패(0)
     */
    public int doSave(ReviewDTO param) {
        int flag = 0;
        Connection conn = connectionMaker.getConnection();
        PreparedStatement pstmt = null;
        
        StringBuilder sb = new StringBuilder();
        
        sb.append(" INSERT INTO v_review (      \n");
        sb.append("     seq,                  \n");
        sb.append("     board_seq,            \n");
        sb.append("     contents,             \n");
        sb.append("     img_link,             \n");
        sb.append("     reg_id,               \n");
        sb.append("     reg_dt,               \n");
        sb.append("     mod_id,               \n");
        sb.append("     mod_dt)               \n");
        sb.append(" VALUES (?, ?, ?, ?, ?, ?, ?, ?)\n");
        
        log.debug("1.sql:{}", sb.toString());
        log.debug("2.conn:{}", conn);
        log.debug("3.param:{}", param);
        
        try {
            pstmt = conn.prepareStatement(sb.toString());
            log.debug("4.pstmt:{}", pstmt);
            
            pstmt.setInt(1, param.getSeq());
            pstmt.setString(2, param.getBoardSeq());
            pstmt.setString(3, param.getContents());
            pstmt.setString(4, param.getImgLink());
            pstmt.setString(5, param.getRegId());
            pstmt.setString(6, param.getRegDt());
            pstmt.setString(7, param.getModId());
            pstmt.setString(8, param.getModDt());
            
            flag = pstmt.executeUpdate();
            log.debug("5.flag:{}", flag);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtill.close(conn, pstmt);
        }
        
        return flag;
    }
    
    /**
     * 리뷰 수정
     * @param param
     * @return 성공(1) 실패(0)
     */
    public int doUpdate(ReviewDTO param) {
        int flag = 0;
        Connection conn = connectionMaker.getConnection();
        PreparedStatement pstmt = null;
        
        StringBuilder sb = new StringBuilder();
        
        sb.append(" UPDATE v_review SET        \n");
        sb.append("     board_seq = ?,         \n");
        sb.append("     contents = ?,          \n");
        sb.append("     img_link = ?,          \n");
        sb.append("     mod_id = ?,            \n");
        sb.append("     mod_dt = ?             \n");
        sb.append(" WHERE seq = ?              \n");
        
        log.debug("1.sql:{}", sb.toString());
        log.debug("2.conn:{}", conn);
        log.debug("3.param:{}", param);
        
        try {
            pstmt = conn.prepareStatement(sb.toString());
            log.debug("4.pstmt:{}", pstmt);
            
            pstmt.setString(1, param.getBoardSeq());
            pstmt.setString(2, param.getContents());
            pstmt.setString(3, param.getImgLink());
            pstmt.setString(4, param.getModId());
            pstmt.setString(5, param.getModDt());
            pstmt.setInt(6, param.getSeq());
            
            flag = pstmt.executeUpdate();
            log.debug("5.flag:{}", flag);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtill.close(conn, pstmt);
        }
        
        return flag;
    }
    
    /**
     * 리뷰 삭제
     * @param param
     * @return 성공(1) 실패(0)
     */
    public int doDelete(ReviewDTO param) {
        int flag = 0;
        Connection conn = connectionMaker.getConnection();
        PreparedStatement pstmt = null;
        
        StringBuilder sb = new StringBuilder();
        
        sb.append(" DELETE FROM v_review \n");
        sb.append(" WHERE seq = ?        \n");
        
        log.debug("1.sql:{}", sb.toString());
        log.debug("2.conn:{}", conn);
        log.debug("3.param:{}", param);
        
        try {
            pstmt = conn.prepareStatement(sb.toString());
            log.debug("4.pstmt:{}", pstmt);
            
            pstmt.setInt(1, param.getSeq());
            
            flag = pstmt.executeUpdate();
            log.debug("5.flag:{}", flag);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtill.close(conn, pstmt);
        }
        
        return flag;
    }

    @Override
    public List<ReviewDTO> doRetrieve(DTO search) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public ReviewDTO doSelectOne(ReviewDTO param) {
        // TODO Auto-generated method stub
        return null;
    }
}
