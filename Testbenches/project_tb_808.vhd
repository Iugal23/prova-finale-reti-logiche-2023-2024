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

constant SCENARIO_LENGTH : integer := 342;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (123,0,131,0,103,0,198,0,0,0,233,0,85,0,139,0,0,0,4,0,71,0,52,0,51,0,196,0,207,0,166,0,182,0,0,0,121,0,159,0,250,0,126,0,55,0,184,0,3,0,117,0,203,0,0,0,122,0,61,0,0,0,76,0,39,0,100,0,104,0,175,0,17,0,56,0,140,0,108,0,124,0,208,0,69,0,15,0,85,0,0,0,76,0,85,0,232,0,139,0,220,0,0,0,0,0,0,0,88,0,178,0,29,0,57,0,227,0,0,0,157,0,12,0,0,0,102,0,245,0,0,0,28,0,66,0,0,0,166,0,212,0,230,0,153,0,200,0,186,0,0,0,116,0,187,0,49,0,0,0,202,0,157,0,221,0,9,0,216,0,239,0,247,0,42,0,0,0,84,0,183,0,0,0,0,0,130,0,109,0,0,0,0,0,0,0,0,0,51,0,232,0,118,0,183,0,153,0,252,0,227,0,0,0,235,0,233,0,211,0,199,0,27,0,84,0,255,0,128,0,59,0,0,0,137,0,205,0,165,0,203,0,231,0,166,0,213,0,244,0,5,0,176,0,219,0,0,0,0,0,98,0,230,0,255,0,5,0,0,0,206,0,0,0,227,0,0,0,2,0,80,0,162,0,121,0,0,0,120,0,100,0,137,0,0,0,5,0,82,0,79,0,0,0,197,0,0,0,242,0,107,0,228,0,158,0,170,0,0,0,112,0,5,0,26,0,4,0,101,0,20,0,151,0,9,0,241,0,178,0,57,0,127,0,101,0,80,0,102,0,243,0,0,0,0,0,143,0,0,0,133,0,0,0,151,0,190,0,78,0,0,0,198,0,69,0,56,0,65,0,17,0,188,0,222,0,0,0,183,0,70,0,30,0,192,0,123,0,83,0,77,0,139,0,34,0,218,0,169,0,53,0,14,0,0,0,62,0,204,0,185,0,129,0,16,0,142,0,92,0,92,0,85,0,65,0,0,0,161,0,90,0,39,0,35,0,176,0,172,0,0,0,0,0,144,0,224,0,106,0,72,0,230,0,184,0,238,0,0,0,0,0,35,0,121,0,95,0,8,0,12,0,0,0,113,0,0,0,106,0,171,0,0,0,243,0,98,0,17,0,160,0,0,0,0,0,46,0,181,0,78,0,141,0,20,0,204,0,157,0,54,0,0,0,112,0,121,0,192,0,163,0,0,0,0,0,66,0,0,0,244,0,0,0,233,0,142,0,107,0,139,0,139,0,155,0,124,0,113,0,182,0,64,0,114,0,83,0,250,0,254,0,0,0,0,0,235,0,139,0,45,0,203,0,138,0,155,0,3,0,143,0,181,0,195,0,134,0,68,0,85,0,200,0,179,0,32,0,116,0,223,0,220,0,80,0,0,0,162,0,174,0,11,0,171,0,128,0,48,0,244,0,6,0,254,0,185,0,213,0,57,0,0,0,219,0,0,0,41,0,0,0,165,0,133,0,0,0,80,0,0,0,197,0,59,0,0,0,0,0,212,0,0,0,87,0,152,0,242,0,128,0,0,0);
signal scenario_full  : scenario_type := (123,31,131,31,103,31,198,31,198,30,233,31,85,31,139,31,139,30,4,31,71,31,52,31,51,31,196,31,207,31,166,31,182,31,182,30,121,31,159,31,250,31,126,31,55,31,184,31,3,31,117,31,203,31,203,30,122,31,61,31,61,30,76,31,39,31,100,31,104,31,175,31,17,31,56,31,140,31,108,31,124,31,208,31,69,31,15,31,85,31,85,30,76,31,85,31,232,31,139,31,220,31,220,30,220,29,220,28,88,31,178,31,29,31,57,31,227,31,227,30,157,31,12,31,12,30,102,31,245,31,245,30,28,31,66,31,66,30,166,31,212,31,230,31,153,31,200,31,186,31,186,30,116,31,187,31,49,31,49,30,202,31,157,31,221,31,9,31,216,31,239,31,247,31,42,31,42,30,84,31,183,31,183,30,183,29,130,31,109,31,109,30,109,29,109,28,109,27,51,31,232,31,118,31,183,31,153,31,252,31,227,31,227,30,235,31,233,31,211,31,199,31,27,31,84,31,255,31,128,31,59,31,59,30,137,31,205,31,165,31,203,31,231,31,166,31,213,31,244,31,5,31,176,31,219,31,219,30,219,29,98,31,230,31,255,31,5,31,5,30,206,31,206,30,227,31,227,30,2,31,80,31,162,31,121,31,121,30,120,31,100,31,137,31,137,30,5,31,82,31,79,31,79,30,197,31,197,30,242,31,107,31,228,31,158,31,170,31,170,30,112,31,5,31,26,31,4,31,101,31,20,31,151,31,9,31,241,31,178,31,57,31,127,31,101,31,80,31,102,31,243,31,243,30,243,29,143,31,143,30,133,31,133,30,151,31,190,31,78,31,78,30,198,31,69,31,56,31,65,31,17,31,188,31,222,31,222,30,183,31,70,31,30,31,192,31,123,31,83,31,77,31,139,31,34,31,218,31,169,31,53,31,14,31,14,30,62,31,204,31,185,31,129,31,16,31,142,31,92,31,92,31,85,31,65,31,65,30,161,31,90,31,39,31,35,31,176,31,172,31,172,30,172,29,144,31,224,31,106,31,72,31,230,31,184,31,238,31,238,30,238,29,35,31,121,31,95,31,8,31,12,31,12,30,113,31,113,30,106,31,171,31,171,30,243,31,98,31,17,31,160,31,160,30,160,29,46,31,181,31,78,31,141,31,20,31,204,31,157,31,54,31,54,30,112,31,121,31,192,31,163,31,163,30,163,29,66,31,66,30,244,31,244,30,233,31,142,31,107,31,139,31,139,31,155,31,124,31,113,31,182,31,64,31,114,31,83,31,250,31,254,31,254,30,254,29,235,31,139,31,45,31,203,31,138,31,155,31,3,31,143,31,181,31,195,31,134,31,68,31,85,31,200,31,179,31,32,31,116,31,223,31,220,31,80,31,80,30,162,31,174,31,11,31,171,31,128,31,48,31,244,31,6,31,254,31,185,31,213,31,57,31,57,30,219,31,219,30,41,31,41,30,165,31,133,31,133,30,80,31,80,30,197,31,59,31,59,30,59,29,212,31,212,30,87,31,152,31,242,31,128,31,128,30);

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
