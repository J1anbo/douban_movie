package org.humingk.movie.service.impl;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.humingk.movie.entity.Movie;
import org.humingk.movie.common.MovieAll;
import org.humingk.movie.mapper.MovieMapper;
import org.humingk.movie.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author humin
 */
@Service
public class MovieServiceImpl implements MovieService {

    private static final Logger LOGGER= LogManager.getLogger(LogManager.ROOT_LOGGER_NAME);

    @Autowired
    private MovieMapper movieMapper;


    /**
     * 根据电影Id找出电影的详细资料
     *
     * @param movieId
     * @return
     */
    @Override
    public MovieAll getMovieAllByMovieId(int movieId) {


        try {
            // 提取电影信息
            MovieAll movieAll=new MovieAll(movieMapper.selectMovieBaseById(movieId));
            movieAll.setDirectors(movieMapper.selectDirectorsOfMovieById(movieId));
            movieAll.setWriters(movieMapper.selectWritersOfMovieById(movieId));
            movieAll.setLeadingactors(movieMapper.selectLeadingactorsOfMovieById(movieId));
            movieAll.setTypes(movieMapper.selectTypesOfMovieById(movieId));
            movieAll.setTags(movieMapper.selectTagsOfMovieById(movieId));
            movieAll.setReleasetimes(movieMapper.selectReleasetimesOfMovieById(movieId));
            return movieAll;
        } catch (Exception e) {
            // 提取失败，查无此电影，添加电影库信息


            try{
                //添加后，再次提取电影信息


            }catch (Exception ee){
                // 添加后，仍提取失败
            }
        }
        return null;
    }


    /**
     * 根据电影名称找出所有电影的所有详细资料
     *
     * @param s
     * @return
     */
    @Override
    public List<MovieAll> getMovieAllsOfMovieByAlias(String s) {
        try {
            List<Movie> movies = movieMapper.selectMoviesByAlias(s);
            if (movies != null) {
                List<MovieAll> movieAlls=new ArrayList<>();
                for (Movie movie : movies) {
                    if (movie != null) {
                        Integer movieId = movie.getMovieId();
                        MovieAll movieAll = new MovieAll(movieMapper.selectMovieBaseById(movieId));
                        movieAll.setDirectors(movieMapper.selectDirectorsOfMovieById(movieId));
                        movieAll.setWriters(movieMapper.selectWritersOfMovieById(movieId));
                        movieAll.setLeadingactors(movieMapper.selectLeadingactorsOfMovieById(movieId));
                        movieAll.setTypes(movieMapper.selectTypesOfMovieById(movieId));
                        movieAll.setTags(movieMapper.selectTagsOfMovieById(movieId));
                        movieAll.setReleasetimes(movieMapper.selectReleasetimesOfMovieById(movieId));
                        movieAlls.add(movieAll);
                    }
                }
                return movieAlls;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据电影名称开头的字符串找出所有电影的基本资料
     * @param s
     * @return
     */
    @Override
    public List<Movie> getMoviesByNameStart(String s) {
       try {
           List<Movie> movies=movieMapper.selectMoviesByNameStart(s);

           if(movies==null){
               LOGGER.error("movies为空,没有此电影...");
               return null;
           }
           return movies;
       }catch (Exception e){
           e.printStackTrace();
       }
        return null;
    }

    /**
     * 更新电影评分
     * @param movieId
     * @param rate
     */
    @Override
    public void updateRateByMovieId(int movieId, float rate) {
        try {
            movieMapper.updateRateByPrimaryKey(movieId,rate);
        }catch (Exception e){
            e.printStackTrace();
        }
    }


    /**
     * 向数据库添加movieAll
     * @param movieAll
     * @return
     */
    @Override
    public Boolean addMovieAll(MovieAll movieAll) {


        return null;
    }
}
