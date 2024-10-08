-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_951 is
end project_tb_951;

architecture project_tb_arch_951 of project_tb_951 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 651;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (31,0,148,0,0,0,94,0,205,0,62,0,0,0,60,0,60,0,151,0,178,0,119,0,42,0,114,0,0,0,66,0,84,0,1,0,64,0,0,0,56,0,32,0,80,0,248,0,107,0,24,0,72,0,238,0,159,0,220,0,151,0,0,0,161,0,49,0,81,0,180,0,255,0,0,0,0,0,28,0,130,0,0,0,255,0,215,0,0,0,195,0,220,0,62,0,193,0,123,0,102,0,47,0,160,0,28,0,0,0,71,0,150,0,27,0,0,0,235,0,135,0,115,0,204,0,66,0,91,0,0,0,28,0,36,0,214,0,160,0,0,0,18,0,4,0,6,0,191,0,4,0,130,0,210,0,0,0,184,0,89,0,246,0,152,0,76,0,219,0,102,0,0,0,0,0,254,0,174,0,44,0,0,0,140,0,199,0,0,0,49,0,0,0,189,0,62,0,124,0,0,0,0,0,113,0,27,0,114,0,0,0,131,0,99,0,4,0,164,0,118,0,189,0,42,0,35,0,77,0,49,0,0,0,89,0,65,0,214,0,15,0,0,0,23,0,235,0,187,0,52,0,0,0,56,0,70,0,217,0,195,0,21,0,0,0,204,0,67,0,226,0,38,0,113,0,253,0,185,0,147,0,97,0,74,0,201,0,193,0,210,0,15,0,142,0,97,0,217,0,209,0,146,0,0,0,70,0,0,0,234,0,0,0,53,0,121,0,215,0,75,0,173,0,0,0,207,0,84,0,0,0,34,0,136,0,89,0,99,0,0,0,76,0,6,0,169,0,169,0,77,0,94,0,168,0,93,0,214,0,156,0,245,0,207,0,112,0,0,0,24,0,0,0,0,0,166,0,254,0,0,0,43,0,166,0,223,0,151,0,117,0,249,0,0,0,60,0,38,0,84,0,131,0,5,0,79,0,196,0,81,0,0,0,201,0,196,0,153,0,249,0,0,0,51,0,98,0,135,0,125,0,118,0,6,0,143,0,178,0,239,0,40,0,189,0,223,0,187,0,54,0,112,0,26,0,20,0,0,0,155,0,103,0,116,0,32,0,120,0,0,0,0,0,101,0,255,0,149,0,0,0,236,0,58,0,247,0,253,0,252,0,164,0,215,0,137,0,209,0,99,0,0,0,43,0,0,0,187,0,109,0,121,0,43,0,0,0,65,0,69,0,43,0,0,0,76,0,22,0,135,0,209,0,84,0,0,0,30,0,95,0,0,0,31,0,80,0,142,0,197,0,132,0,179,0,0,0,133,0,32,0,248,0,137,0,163,0,16,0,6,0,161,0,0,0,146,0,171,0,200,0,169,0,0,0,229,0,0,0,8,0,57,0,35,0,57,0,0,0,64,0,215,0,245,0,75,0,0,0,254,0,183,0,27,0,187,0,77,0,205,0,204,0,120,0,107,0,75,0,156,0,122,0,77,0,189,0,2,0,70,0,17,0,220,0,96,0,55,0,55,0,226,0,79,0,217,0,0,0,215,0,13,0,214,0,70,0,220,0,56,0,213,0,169,0,53,0,113,0,44,0,0,0,42,0,239,0,0,0,224,0,39,0,0,0,0,0,97,0,0,0,100,0,251,0,96,0,2,0,249,0,248,0,57,0,26,0,158,0,221,0,0,0,183,0,0,0,49,0,123,0,136,0,248,0,253,0,125,0,80,0,248,0,204,0,115,0,222,0,255,0,0,0,129,0,234,0,61,0,165,0,138,0,53,0,243,0,180,0,0,0,207,0,148,0,156,0,0,0,230,0,73,0,137,0,206,0,8,0,14,0,160,0,0,0,0,0,0,0,125,0,124,0,49,0,243,0,0,0,255,0,146,0,137,0,0,0,250,0,7,0,49,0,156,0,65,0,160,0,214,0,0,0,234,0,24,0,199,0,254,0,0,0,0,0,118,0,188,0,60,0,32,0,0,0,52,0,1,0,0,0,218,0,0,0,227,0,0,0,179,0,164,0,144,0,0,0,171,0,234,0,72,0,0,0,0,0,42,0,112,0,0,0,195,0,0,0,222,0,42,0,249,0,14,0,177,0,12,0,92,0,239,0,119,0,23,0,0,0,0,0,0,0,4,0,44,0,134,0,23,0,52,0,0,0,81,0,98,0,40,0,172,0,97,0,235,0,83,0,232,0,209,0,208,0,55,0,79,0,146,0,162,0,216,0,57,0,20,0,248,0,28,0,200,0,77,0,0,0,76,0,0,0,144,0,234,0,186,0,50,0,91,0,0,0,0,0,41,0,247,0,109,0,38,0,219,0,0,0,133,0,0,0,55,0,48,0,235,0,195,0,0,0,131,0,0,0,0,0,157,0,202,0,22,0,80,0,120,0,163,0,0,0,20,0,178,0,0,0,0,0,77,0,188,0,239,0,252,0,0,0,171,0,205,0,0,0,171,0,176,0,39,0,29,0,55,0,36,0,32,0,151,0,148,0,0,0,251,0,134,0,130,0,139,0,59,0,243,0,124,0,99,0,226,0,157,0,91,0,65,0,0,0,31,0,0,0,238,0,0,0,65,0,69,0,18,0,153,0,79,0,0,0,136,0,0,0,224,0,178,0,34,0,0,0,27,0,171,0,225,0,1,0,0,0,200,0,117,0,191,0,8,0,50,0,157,0,31,0,96,0,24,0,9,0,120,0,142,0,83,0,235,0,179,0,145,0,148,0,245,0,0,0,105,0,130,0,51,0,0,0,159,0,231,0,139,0,198,0,143,0,142,0,119,0,78,0,114,0,132,0,0,0,198,0,0,0,0,0,119,0,0,0,192,0,61,0,139,0,185,0,79,0,238,0,187,0,0,0,54,0,71,0,90,0,0,0,101,0,105,0,13,0,245,0,184,0,59,0,0,0,170,0,47,0,96,0,97,0,0,0,210,0,0,0,186,0,0,0,82,0,185,0,108,0,26,0,0,0,184,0);
signal scenario_full  : scenario_type := (31,31,148,31,148,30,94,31,205,31,62,31,62,30,60,31,60,31,151,31,178,31,119,31,42,31,114,31,114,30,66,31,84,31,1,31,64,31,64,30,56,31,32,31,80,31,248,31,107,31,24,31,72,31,238,31,159,31,220,31,151,31,151,30,161,31,49,31,81,31,180,31,255,31,255,30,255,29,28,31,130,31,130,30,255,31,215,31,215,30,195,31,220,31,62,31,193,31,123,31,102,31,47,31,160,31,28,31,28,30,71,31,150,31,27,31,27,30,235,31,135,31,115,31,204,31,66,31,91,31,91,30,28,31,36,31,214,31,160,31,160,30,18,31,4,31,6,31,191,31,4,31,130,31,210,31,210,30,184,31,89,31,246,31,152,31,76,31,219,31,102,31,102,30,102,29,254,31,174,31,44,31,44,30,140,31,199,31,199,30,49,31,49,30,189,31,62,31,124,31,124,30,124,29,113,31,27,31,114,31,114,30,131,31,99,31,4,31,164,31,118,31,189,31,42,31,35,31,77,31,49,31,49,30,89,31,65,31,214,31,15,31,15,30,23,31,235,31,187,31,52,31,52,30,56,31,70,31,217,31,195,31,21,31,21,30,204,31,67,31,226,31,38,31,113,31,253,31,185,31,147,31,97,31,74,31,201,31,193,31,210,31,15,31,142,31,97,31,217,31,209,31,146,31,146,30,70,31,70,30,234,31,234,30,53,31,121,31,215,31,75,31,173,31,173,30,207,31,84,31,84,30,34,31,136,31,89,31,99,31,99,30,76,31,6,31,169,31,169,31,77,31,94,31,168,31,93,31,214,31,156,31,245,31,207,31,112,31,112,30,24,31,24,30,24,29,166,31,254,31,254,30,43,31,166,31,223,31,151,31,117,31,249,31,249,30,60,31,38,31,84,31,131,31,5,31,79,31,196,31,81,31,81,30,201,31,196,31,153,31,249,31,249,30,51,31,98,31,135,31,125,31,118,31,6,31,143,31,178,31,239,31,40,31,189,31,223,31,187,31,54,31,112,31,26,31,20,31,20,30,155,31,103,31,116,31,32,31,120,31,120,30,120,29,101,31,255,31,149,31,149,30,236,31,58,31,247,31,253,31,252,31,164,31,215,31,137,31,209,31,99,31,99,30,43,31,43,30,187,31,109,31,121,31,43,31,43,30,65,31,69,31,43,31,43,30,76,31,22,31,135,31,209,31,84,31,84,30,30,31,95,31,95,30,31,31,80,31,142,31,197,31,132,31,179,31,179,30,133,31,32,31,248,31,137,31,163,31,16,31,6,31,161,31,161,30,146,31,171,31,200,31,169,31,169,30,229,31,229,30,8,31,57,31,35,31,57,31,57,30,64,31,215,31,245,31,75,31,75,30,254,31,183,31,27,31,187,31,77,31,205,31,204,31,120,31,107,31,75,31,156,31,122,31,77,31,189,31,2,31,70,31,17,31,220,31,96,31,55,31,55,31,226,31,79,31,217,31,217,30,215,31,13,31,214,31,70,31,220,31,56,31,213,31,169,31,53,31,113,31,44,31,44,30,42,31,239,31,239,30,224,31,39,31,39,30,39,29,97,31,97,30,100,31,251,31,96,31,2,31,249,31,248,31,57,31,26,31,158,31,221,31,221,30,183,31,183,30,49,31,123,31,136,31,248,31,253,31,125,31,80,31,248,31,204,31,115,31,222,31,255,31,255,30,129,31,234,31,61,31,165,31,138,31,53,31,243,31,180,31,180,30,207,31,148,31,156,31,156,30,230,31,73,31,137,31,206,31,8,31,14,31,160,31,160,30,160,29,160,28,125,31,124,31,49,31,243,31,243,30,255,31,146,31,137,31,137,30,250,31,7,31,49,31,156,31,65,31,160,31,214,31,214,30,234,31,24,31,199,31,254,31,254,30,254,29,118,31,188,31,60,31,32,31,32,30,52,31,1,31,1,30,218,31,218,30,227,31,227,30,179,31,164,31,144,31,144,30,171,31,234,31,72,31,72,30,72,29,42,31,112,31,112,30,195,31,195,30,222,31,42,31,249,31,14,31,177,31,12,31,92,31,239,31,119,31,23,31,23,30,23,29,23,28,4,31,44,31,134,31,23,31,52,31,52,30,81,31,98,31,40,31,172,31,97,31,235,31,83,31,232,31,209,31,208,31,55,31,79,31,146,31,162,31,216,31,57,31,20,31,248,31,28,31,200,31,77,31,77,30,76,31,76,30,144,31,234,31,186,31,50,31,91,31,91,30,91,29,41,31,247,31,109,31,38,31,219,31,219,30,133,31,133,30,55,31,48,31,235,31,195,31,195,30,131,31,131,30,131,29,157,31,202,31,22,31,80,31,120,31,163,31,163,30,20,31,178,31,178,30,178,29,77,31,188,31,239,31,252,31,252,30,171,31,205,31,205,30,171,31,176,31,39,31,29,31,55,31,36,31,32,31,151,31,148,31,148,30,251,31,134,31,130,31,139,31,59,31,243,31,124,31,99,31,226,31,157,31,91,31,65,31,65,30,31,31,31,30,238,31,238,30,65,31,69,31,18,31,153,31,79,31,79,30,136,31,136,30,224,31,178,31,34,31,34,30,27,31,171,31,225,31,1,31,1,30,200,31,117,31,191,31,8,31,50,31,157,31,31,31,96,31,24,31,9,31,120,31,142,31,83,31,235,31,179,31,145,31,148,31,245,31,245,30,105,31,130,31,51,31,51,30,159,31,231,31,139,31,198,31,143,31,142,31,119,31,78,31,114,31,132,31,132,30,198,31,198,30,198,29,119,31,119,30,192,31,61,31,139,31,185,31,79,31,238,31,187,31,187,30,54,31,71,31,90,31,90,30,101,31,105,31,13,31,245,31,184,31,59,31,59,30,170,31,47,31,96,31,97,31,97,30,210,31,210,30,186,31,186,30,82,31,185,31,108,31,26,31,26,30,184,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
