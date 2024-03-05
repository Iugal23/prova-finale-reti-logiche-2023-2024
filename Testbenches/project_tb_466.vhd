-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 549;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (77,0,10,0,49,0,183,0,0,0,164,0,244,0,52,0,226,0,0,0,143,0,0,0,93,0,99,0,0,0,0,0,54,0,48,0,121,0,43,0,141,0,42,0,19,0,115,0,0,0,92,0,0,0,251,0,224,0,142,0,233,0,154,0,0,0,60,0,111,0,234,0,124,0,195,0,62,0,176,0,93,0,137,0,75,0,255,0,199,0,0,0,90,0,0,0,22,0,221,0,209,0,10,0,182,0,171,0,214,0,115,0,252,0,0,0,113,0,255,0,177,0,235,0,65,0,91,0,20,0,0,0,175,0,227,0,0,0,0,0,47,0,201,0,111,0,88,0,156,0,75,0,0,0,243,0,4,0,19,0,116,0,196,0,0,0,0,0,0,0,53,0,0,0,97,0,0,0,104,0,95,0,0,0,127,0,47,0,0,0,117,0,221,0,223,0,161,0,226,0,124,0,32,0,31,0,0,0,82,0,207,0,87,0,0,0,60,0,181,0,0,0,18,0,232,0,0,0,237,0,162,0,212,0,235,0,73,0,0,0,2,0,226,0,120,0,0,0,197,0,107,0,91,0,94,0,170,0,167,0,11,0,22,0,198,0,114,0,26,0,219,0,155,0,245,0,101,0,78,0,0,0,254,0,244,0,0,0,252,0,0,0,174,0,0,0,86,0,0,0,0,0,80,0,148,0,238,0,38,0,0,0,0,0,25,0,127,0,146,0,27,0,173,0,172,0,109,0,0,0,188,0,110,0,87,0,247,0,254,0,225,0,0,0,173,0,0,0,199,0,58,0,0,0,63,0,71,0,0,0,140,0,179,0,0,0,74,0,135,0,211,0,137,0,0,0,90,0,22,0,106,0,24,0,67,0,4,0,110,0,0,0,121,0,124,0,174,0,142,0,130,0,0,0,43,0,31,0,49,0,0,0,240,0,52,0,180,0,233,0,21,0,0,0,191,0,218,0,21,0,46,0,1,0,91,0,72,0,147,0,83,0,147,0,0,0,43,0,230,0,110,0,182,0,52,0,253,0,88,0,215,0,213,0,0,0,90,0,0,0,132,0,19,0,0,0,12,0,201,0,0,0,166,0,19,0,115,0,0,0,106,0,123,0,89,0,47,0,84,0,130,0,181,0,0,0,74,0,9,0,66,0,70,0,31,0,228,0,234,0,55,0,106,0,141,0,111,0,229,0,165,0,25,0,205,0,193,0,0,0,183,0,168,0,180,0,40,0,172,0,164,0,249,0,0,0,101,0,137,0,126,0,222,0,0,0,214,0,138,0,202,0,238,0,60,0,112,0,120,0,179,0,233,0,192,0,255,0,19,0,34,0,133,0,181,0,169,0,139,0,210,0,246,0,0,0,68,0,27,0,76,0,0,0,113,0,189,0,65,0,223,0,170,0,149,0,67,0,0,0,175,0,116,0,162,0,0,0,54,0,0,0,0,0,59,0,175,0,14,0,108,0,98,0,146,0,253,0,102,0,28,0,73,0,206,0,79,0,58,0,59,0,37,0,240,0,203,0,102,0,41,0,53,0,54,0,0,0,122,0,0,0,0,0,223,0,196,0,250,0,187,0,0,0,2,0,0,0,88,0,156,0,0,0,0,0,0,0,179,0,192,0,212,0,0,0,0,0,0,0,18,0,212,0,0,0,15,0,117,0,237,0,142,0,42,0,56,0,71,0,210,0,224,0,248,0,133,0,91,0,0,0,98,0,253,0,0,0,147,0,0,0,234,0,251,0,67,0,205,0,226,0,20,0,120,0,0,0,96,0,108,0,162,0,181,0,41,0,159,0,192,0,186,0,179,0,21,0,9,0,61,0,83,0,90,0,33,0,100,0,21,0,78,0,142,0,64,0,173,0,183,0,94,0,222,0,39,0,0,0,0,0,128,0,53,0,162,0,95,0,248,0,174,0,0,0,0,0,29,0,82,0,119,0,14,0,0,0,151,0,63,0,220,0,65,0,62,0,59,0,166,0,57,0,112,0,0,0,117,0,150,0,27,0,65,0,234,0,216,0,210,0,67,0,83,0,33,0,0,0,227,0,152,0,52,0,95,0,90,0,130,0,98,0,73,0,0,0,125,0,0,0,123,0,24,0,115,0,212,0,36,0,109,0,0,0,237,0,198,0,63,0,198,0,182,0,0,0,8,0,0,0,89,0,45,0,195,0,0,0,0,0,184,0,0,0,92,0,184,0,0,0,171,0,200,0,71,0,213,0,161,0,98,0,98,0,0,0,108,0,234,0,57,0,67,0,65,0,83,0,223,0,88,0,168,0,20,0,213,0,14,0,35,0,35,0,67,0,17,0,113,0,142,0,0,0,0,0,125,0,202,0,81,0,0,0,0,0,0,0,106,0,0,0,0,0,89,0,52,0,129,0,164,0,195,0,12,0,156,0,246,0,89,0,148,0,81,0,48,0,149,0,57,0,107,0,0,0,0,0,82,0,0,0,191,0,20,0);
signal scenario_full  : scenario_type := (77,31,10,31,49,31,183,31,183,30,164,31,244,31,52,31,226,31,226,30,143,31,143,30,93,31,99,31,99,30,99,29,54,31,48,31,121,31,43,31,141,31,42,31,19,31,115,31,115,30,92,31,92,30,251,31,224,31,142,31,233,31,154,31,154,30,60,31,111,31,234,31,124,31,195,31,62,31,176,31,93,31,137,31,75,31,255,31,199,31,199,30,90,31,90,30,22,31,221,31,209,31,10,31,182,31,171,31,214,31,115,31,252,31,252,30,113,31,255,31,177,31,235,31,65,31,91,31,20,31,20,30,175,31,227,31,227,30,227,29,47,31,201,31,111,31,88,31,156,31,75,31,75,30,243,31,4,31,19,31,116,31,196,31,196,30,196,29,196,28,53,31,53,30,97,31,97,30,104,31,95,31,95,30,127,31,47,31,47,30,117,31,221,31,223,31,161,31,226,31,124,31,32,31,31,31,31,30,82,31,207,31,87,31,87,30,60,31,181,31,181,30,18,31,232,31,232,30,237,31,162,31,212,31,235,31,73,31,73,30,2,31,226,31,120,31,120,30,197,31,107,31,91,31,94,31,170,31,167,31,11,31,22,31,198,31,114,31,26,31,219,31,155,31,245,31,101,31,78,31,78,30,254,31,244,31,244,30,252,31,252,30,174,31,174,30,86,31,86,30,86,29,80,31,148,31,238,31,38,31,38,30,38,29,25,31,127,31,146,31,27,31,173,31,172,31,109,31,109,30,188,31,110,31,87,31,247,31,254,31,225,31,225,30,173,31,173,30,199,31,58,31,58,30,63,31,71,31,71,30,140,31,179,31,179,30,74,31,135,31,211,31,137,31,137,30,90,31,22,31,106,31,24,31,67,31,4,31,110,31,110,30,121,31,124,31,174,31,142,31,130,31,130,30,43,31,31,31,49,31,49,30,240,31,52,31,180,31,233,31,21,31,21,30,191,31,218,31,21,31,46,31,1,31,91,31,72,31,147,31,83,31,147,31,147,30,43,31,230,31,110,31,182,31,52,31,253,31,88,31,215,31,213,31,213,30,90,31,90,30,132,31,19,31,19,30,12,31,201,31,201,30,166,31,19,31,115,31,115,30,106,31,123,31,89,31,47,31,84,31,130,31,181,31,181,30,74,31,9,31,66,31,70,31,31,31,228,31,234,31,55,31,106,31,141,31,111,31,229,31,165,31,25,31,205,31,193,31,193,30,183,31,168,31,180,31,40,31,172,31,164,31,249,31,249,30,101,31,137,31,126,31,222,31,222,30,214,31,138,31,202,31,238,31,60,31,112,31,120,31,179,31,233,31,192,31,255,31,19,31,34,31,133,31,181,31,169,31,139,31,210,31,246,31,246,30,68,31,27,31,76,31,76,30,113,31,189,31,65,31,223,31,170,31,149,31,67,31,67,30,175,31,116,31,162,31,162,30,54,31,54,30,54,29,59,31,175,31,14,31,108,31,98,31,146,31,253,31,102,31,28,31,73,31,206,31,79,31,58,31,59,31,37,31,240,31,203,31,102,31,41,31,53,31,54,31,54,30,122,31,122,30,122,29,223,31,196,31,250,31,187,31,187,30,2,31,2,30,88,31,156,31,156,30,156,29,156,28,179,31,192,31,212,31,212,30,212,29,212,28,18,31,212,31,212,30,15,31,117,31,237,31,142,31,42,31,56,31,71,31,210,31,224,31,248,31,133,31,91,31,91,30,98,31,253,31,253,30,147,31,147,30,234,31,251,31,67,31,205,31,226,31,20,31,120,31,120,30,96,31,108,31,162,31,181,31,41,31,159,31,192,31,186,31,179,31,21,31,9,31,61,31,83,31,90,31,33,31,100,31,21,31,78,31,142,31,64,31,173,31,183,31,94,31,222,31,39,31,39,30,39,29,128,31,53,31,162,31,95,31,248,31,174,31,174,30,174,29,29,31,82,31,119,31,14,31,14,30,151,31,63,31,220,31,65,31,62,31,59,31,166,31,57,31,112,31,112,30,117,31,150,31,27,31,65,31,234,31,216,31,210,31,67,31,83,31,33,31,33,30,227,31,152,31,52,31,95,31,90,31,130,31,98,31,73,31,73,30,125,31,125,30,123,31,24,31,115,31,212,31,36,31,109,31,109,30,237,31,198,31,63,31,198,31,182,31,182,30,8,31,8,30,89,31,45,31,195,31,195,30,195,29,184,31,184,30,92,31,184,31,184,30,171,31,200,31,71,31,213,31,161,31,98,31,98,31,98,30,108,31,234,31,57,31,67,31,65,31,83,31,223,31,88,31,168,31,20,31,213,31,14,31,35,31,35,31,67,31,17,31,113,31,142,31,142,30,142,29,125,31,202,31,81,31,81,30,81,29,81,28,106,31,106,30,106,29,89,31,52,31,129,31,164,31,195,31,12,31,156,31,246,31,89,31,148,31,81,31,48,31,149,31,57,31,107,31,107,30,107,29,82,31,82,30,191,31,20,31);

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
