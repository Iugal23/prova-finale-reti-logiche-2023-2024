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

constant SCENARIO_LENGTH : integer := 592;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (118,0,11,0,217,0,6,0,212,0,0,0,24,0,4,0,198,0,20,0,22,0,121,0,56,0,170,0,116,0,112,0,59,0,114,0,223,0,0,0,153,0,169,0,0,0,126,0,92,0,53,0,0,0,87,0,2,0,229,0,44,0,111,0,176,0,48,0,107,0,0,0,60,0,2,0,235,0,143,0,20,0,247,0,163,0,0,0,95,0,120,0,185,0,127,0,18,0,219,0,12,0,0,0,0,0,131,0,169,0,0,0,200,0,217,0,1,0,0,0,148,0,0,0,166,0,103,0,108,0,0,0,0,0,0,0,185,0,27,0,184,0,230,0,238,0,166,0,0,0,172,0,240,0,0,0,240,0,0,0,192,0,133,0,134,0,115,0,0,0,0,0,207,0,125,0,130,0,184,0,26,0,90,0,81,0,9,0,58,0,143,0,77,0,0,0,0,0,240,0,122,0,9,0,186,0,234,0,179,0,231,0,14,0,133,0,241,0,69,0,134,0,52,0,37,0,85,0,232,0,187,0,163,0,0,0,102,0,90,0,0,0,70,0,218,0,79,0,75,0,175,0,0,0,216,0,121,0,110,0,83,0,176,0,221,0,0,0,109,0,0,0,48,0,122,0,185,0,12,0,195,0,153,0,219,0,0,0,202,0,186,0,65,0,157,0,182,0,248,0,226,0,184,0,19,0,159,0,215,0,195,0,189,0,194,0,0,0,19,0,191,0,167,0,66,0,6,0,43,0,0,0,164,0,161,0,39,0,227,0,245,0,187,0,82,0,161,0,14,0,201,0,0,0,103,0,117,0,132,0,61,0,225,0,0,0,38,0,165,0,205,0,0,0,0,0,251,0,231,0,2,0,13,0,210,0,13,0,183,0,231,0,0,0,160,0,0,0,0,0,126,0,92,0,0,0,222,0,28,0,234,0,0,0,0,0,8,0,176,0,0,0,0,0,0,0,208,0,114,0,217,0,198,0,94,0,0,0,5,0,208,0,38,0,71,0,158,0,186,0,0,0,144,0,208,0,0,0,108,0,164,0,158,0,0,0,0,0,230,0,88,0,229,0,0,0,143,0,69,0,0,0,0,0,72,0,233,0,100,0,130,0,223,0,98,0,0,0,0,0,0,0,73,0,94,0,103,0,150,0,0,0,162,0,74,0,175,0,206,0,112,0,172,0,47,0,173,0,13,0,219,0,221,0,195,0,214,0,200,0,254,0,187,0,189,0,72,0,188,0,82,0,90,0,0,0,140,0,160,0,244,0,0,0,193,0,144,0,216,0,135,0,82,0,141,0,51,0,118,0,237,0,62,0,213,0,145,0,198,0,255,0,163,0,125,0,0,0,119,0,135,0,53,0,235,0,0,0,0,0,65,0,91,0,111,0,167,0,24,0,75,0,156,0,0,0,93,0,110,0,0,0,0,0,128,0,132,0,93,0,121,0,0,0,0,0,0,0,67,0,55,0,223,0,0,0,149,0,191,0,0,0,163,0,85,0,191,0,210,0,80,0,96,0,35,0,193,0,24,0,175,0,0,0,125,0,33,0,15,0,146,0,152,0,0,0,0,0,193,0,120,0,0,0,192,0,176,0,246,0,230,0,154,0,28,0,180,0,205,0,169,0,46,0,191,0,253,0,0,0,207,0,111,0,159,0,25,0,176,0,46,0,205,0,48,0,120,0,0,0,153,0,0,0,0,0,24,0,199,0,183,0,255,0,40,0,41,0,119,0,124,0,251,0,134,0,133,0,96,0,63,0,79,0,147,0,98,0,238,0,0,0,170,0,35,0,108,0,0,0,229,0,244,0,192,0,205,0,0,0,122,0,121,0,45,0,0,0,75,0,0,0,0,0,87,0,0,0,135,0,239,0,246,0,158,0,183,0,244,0,167,0,168,0,163,0,204,0,141,0,83,0,223,0,26,0,200,0,40,0,54,0,136,0,213,0,198,0,186,0,107,0,0,0,0,0,93,0,0,0,0,0,84,0,97,0,133,0,102,0,0,0,20,0,171,0,171,0,99,0,117,0,21,0,252,0,152,0,232,0,172,0,0,0,0,0,177,0,0,0,235,0,118,0,0,0,0,0,73,0,143,0,110,0,0,0,44,0,203,0,38,0,58,0,98,0,108,0,108,0,0,0,131,0,135,0,253,0,14,0,131,0,34,0,13,0,248,0,106,0,112,0,226,0,0,0,69,0,0,0,100,0,167,0,0,0,186,0,151,0,62,0,0,0,91,0,0,0,210,0,118,0,107,0,153,0,144,0,62,0,218,0,0,0,170,0,0,0,111,0,0,0,152,0,0,0,246,0,0,0,248,0,65,0,101,0,154,0,206,0,108,0,100,0,44,0,0,0,62,0,48,0,142,0,98,0,0,0,98,0,201,0,0,0,124,0,0,0,0,0,0,0,243,0,61,0,234,0,170,0,143,0,218,0,94,0,0,0,162,0,159,0,134,0,101,0,99,0,113,0,222,0,74,0,213,0,106,0,128,0,43,0,103,0,15,0,245,0,0,0,60,0,34,0,212,0,106,0,17,0,223,0,0,0,0,0,175,0,172,0,0,0,0,0,0,0,0,0,74,0,135,0,0,0,237,0,0,0,22,0,237,0,188,0,0,0,90,0,250,0,65,0,165,0,137,0,226,0,0,0,249,0,2,0);
signal scenario_full  : scenario_type := (118,31,11,31,217,31,6,31,212,31,212,30,24,31,4,31,198,31,20,31,22,31,121,31,56,31,170,31,116,31,112,31,59,31,114,31,223,31,223,30,153,31,169,31,169,30,126,31,92,31,53,31,53,30,87,31,2,31,229,31,44,31,111,31,176,31,48,31,107,31,107,30,60,31,2,31,235,31,143,31,20,31,247,31,163,31,163,30,95,31,120,31,185,31,127,31,18,31,219,31,12,31,12,30,12,29,131,31,169,31,169,30,200,31,217,31,1,31,1,30,148,31,148,30,166,31,103,31,108,31,108,30,108,29,108,28,185,31,27,31,184,31,230,31,238,31,166,31,166,30,172,31,240,31,240,30,240,31,240,30,192,31,133,31,134,31,115,31,115,30,115,29,207,31,125,31,130,31,184,31,26,31,90,31,81,31,9,31,58,31,143,31,77,31,77,30,77,29,240,31,122,31,9,31,186,31,234,31,179,31,231,31,14,31,133,31,241,31,69,31,134,31,52,31,37,31,85,31,232,31,187,31,163,31,163,30,102,31,90,31,90,30,70,31,218,31,79,31,75,31,175,31,175,30,216,31,121,31,110,31,83,31,176,31,221,31,221,30,109,31,109,30,48,31,122,31,185,31,12,31,195,31,153,31,219,31,219,30,202,31,186,31,65,31,157,31,182,31,248,31,226,31,184,31,19,31,159,31,215,31,195,31,189,31,194,31,194,30,19,31,191,31,167,31,66,31,6,31,43,31,43,30,164,31,161,31,39,31,227,31,245,31,187,31,82,31,161,31,14,31,201,31,201,30,103,31,117,31,132,31,61,31,225,31,225,30,38,31,165,31,205,31,205,30,205,29,251,31,231,31,2,31,13,31,210,31,13,31,183,31,231,31,231,30,160,31,160,30,160,29,126,31,92,31,92,30,222,31,28,31,234,31,234,30,234,29,8,31,176,31,176,30,176,29,176,28,208,31,114,31,217,31,198,31,94,31,94,30,5,31,208,31,38,31,71,31,158,31,186,31,186,30,144,31,208,31,208,30,108,31,164,31,158,31,158,30,158,29,230,31,88,31,229,31,229,30,143,31,69,31,69,30,69,29,72,31,233,31,100,31,130,31,223,31,98,31,98,30,98,29,98,28,73,31,94,31,103,31,150,31,150,30,162,31,74,31,175,31,206,31,112,31,172,31,47,31,173,31,13,31,219,31,221,31,195,31,214,31,200,31,254,31,187,31,189,31,72,31,188,31,82,31,90,31,90,30,140,31,160,31,244,31,244,30,193,31,144,31,216,31,135,31,82,31,141,31,51,31,118,31,237,31,62,31,213,31,145,31,198,31,255,31,163,31,125,31,125,30,119,31,135,31,53,31,235,31,235,30,235,29,65,31,91,31,111,31,167,31,24,31,75,31,156,31,156,30,93,31,110,31,110,30,110,29,128,31,132,31,93,31,121,31,121,30,121,29,121,28,67,31,55,31,223,31,223,30,149,31,191,31,191,30,163,31,85,31,191,31,210,31,80,31,96,31,35,31,193,31,24,31,175,31,175,30,125,31,33,31,15,31,146,31,152,31,152,30,152,29,193,31,120,31,120,30,192,31,176,31,246,31,230,31,154,31,28,31,180,31,205,31,169,31,46,31,191,31,253,31,253,30,207,31,111,31,159,31,25,31,176,31,46,31,205,31,48,31,120,31,120,30,153,31,153,30,153,29,24,31,199,31,183,31,255,31,40,31,41,31,119,31,124,31,251,31,134,31,133,31,96,31,63,31,79,31,147,31,98,31,238,31,238,30,170,31,35,31,108,31,108,30,229,31,244,31,192,31,205,31,205,30,122,31,121,31,45,31,45,30,75,31,75,30,75,29,87,31,87,30,135,31,239,31,246,31,158,31,183,31,244,31,167,31,168,31,163,31,204,31,141,31,83,31,223,31,26,31,200,31,40,31,54,31,136,31,213,31,198,31,186,31,107,31,107,30,107,29,93,31,93,30,93,29,84,31,97,31,133,31,102,31,102,30,20,31,171,31,171,31,99,31,117,31,21,31,252,31,152,31,232,31,172,31,172,30,172,29,177,31,177,30,235,31,118,31,118,30,118,29,73,31,143,31,110,31,110,30,44,31,203,31,38,31,58,31,98,31,108,31,108,31,108,30,131,31,135,31,253,31,14,31,131,31,34,31,13,31,248,31,106,31,112,31,226,31,226,30,69,31,69,30,100,31,167,31,167,30,186,31,151,31,62,31,62,30,91,31,91,30,210,31,118,31,107,31,153,31,144,31,62,31,218,31,218,30,170,31,170,30,111,31,111,30,152,31,152,30,246,31,246,30,248,31,65,31,101,31,154,31,206,31,108,31,100,31,44,31,44,30,62,31,48,31,142,31,98,31,98,30,98,31,201,31,201,30,124,31,124,30,124,29,124,28,243,31,61,31,234,31,170,31,143,31,218,31,94,31,94,30,162,31,159,31,134,31,101,31,99,31,113,31,222,31,74,31,213,31,106,31,128,31,43,31,103,31,15,31,245,31,245,30,60,31,34,31,212,31,106,31,17,31,223,31,223,30,223,29,175,31,172,31,172,30,172,29,172,28,172,27,74,31,135,31,135,30,237,31,237,30,22,31,237,31,188,31,188,30,90,31,250,31,65,31,165,31,137,31,226,31,226,30,249,31,2,31);

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
