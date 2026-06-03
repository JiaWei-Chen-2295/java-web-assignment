package fun.javierchen.noteapp.servlet;

import fun.javierchen.noteapp.mapper.LinkMapper;
import fun.javierchen.noteapp.mapper.NoteMapper;
import fun.javierchen.noteapp.model.dto.GraphData;
import fun.javierchen.noteapp.model.entity.Folder;
import fun.javierchen.noteapp.model.entity.Note;
import fun.javierchen.noteapp.model.entity.NoteLink;
import fun.javierchen.noteapp.model.entity.User;
import fun.javierchen.noteapp.service.FolderService;
import fun.javierchen.noteapp.util.DBUtil;
import fun.javierchen.noteapp.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/graph", "/api/graph"})
public class GraphServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/graph".equals(servletPath)) {
            // Load folder tree for sidebar
            User currentUser = (User) req.getSession().getAttribute("currentUser");
            FolderService folderService = new FolderService();
            List<Folder> folderTree = folderService.getFolderTree(currentUser.getId());
            req.setAttribute("folderTree", folderTree);
            req.setAttribute("activeNav", "graph");
            req.setAttribute("breadcrumb", "知识图谱");
            req.getRequestDispatcher("/WEB-INF/views/graph.jsp").forward(req, resp);
        } else if ("/api/graph".equals(servletPath)) {
            handleGraphData(req, resp);
        }
    }

    private void handleGraphData(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        long userId = currentUser.getId();

        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            LinkMapper linkMapper = session.getMapper(LinkMapper.class);

            List<Note> notes = noteMapper.selectByUserId(userId);

            // Collect all note IDs for filtering edges
            Map<Long, Boolean> noteIdSet = new HashMap<>();
            for (Note note : notes) {
                noteIdSet.put(note.getId(), true);
            }

            // Count links per note for node sizing and collect edges
            Map<Long, Integer> linkCountMap = new HashMap<>();
            List<GraphData.GraphEdge> edges = new ArrayList<>();

            for (Note note : notes) {
                List<NoteLink> links = linkMapper.selectBySourceId(note.getId());
                for (NoteLink link : links) {
                    linkCountMap.merge(link.getSourceId(), 1, Integer::sum);
                    linkCountMap.merge(link.getTargetId(), 1, Integer::sum);
                    // Only include edges where both ends belong to current user
                    if (noteIdSet.containsKey(link.getTargetId())) {
                        GraphData.GraphEdge edge = new GraphData.GraphEdge();
                        edge.setSource(link.getSourceId());
                        edge.setTarget(link.getTargetId());
                        edges.add(edge);
                    }
                }
            }

            // Build nodes
            List<GraphData.GraphNode> nodes = new ArrayList<>();
            for (Note note : notes) {
                GraphData.GraphNode node = new GraphData.GraphNode();
                node.setId(note.getId());
                node.setTitle(note.getTitle());
                node.setLinks(linkCountMap.getOrDefault(note.getId(), 0));
                nodes.add(node);
            }

            GraphData graphData = new GraphData();
            graphData.setNodes(nodes);
            graphData.setEdges(edges);

            JsonUtil.writeJson(resp, graphData);
        } finally {
            session.close();
        }
    }
}
