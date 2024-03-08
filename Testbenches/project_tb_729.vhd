-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_729 is
end project_tb_729;

architecture project_tb_arch_729 of project_tb_729 is
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

constant SCENARIO_LENGTH : integer := 316;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,172,0,0,0,254,0,54,0,88,0,117,0,152,0,182,0,0,0,175,0,0,0,0,0,200,0,58,0,229,0,195,0,0,0,181,0,140,0,56,0,121,0,236,0,0,0,0,0,0,0,96,0,0,0,0,0,64,0,243,0,245,0,0,0,135,0,230,0,245,0,25,0,90,0,57,0,62,0,0,0,0,0,0,0,0,0,0,0,19,0,134,0,0,0,86,0,66,0,34,0,128,0,97,0,104,0,83,0,234,0,29,0,179,0,0,0,27,0,36,0,79,0,12,0,1,0,129,0,181,0,22,0,0,0,129,0,187,0,134,0,161,0,17,0,210,0,249,0,50,0,252,0,228,0,11,0,184,0,143,0,151,0,37,0,254,0,119,0,186,0,0,0,123,0,0,0,80,0,0,0,230,0,137,0,215,0,251,0,144,0,79,0,96,0,190,0,230,0,135,0,104,0,0,0,176,0,82,0,112,0,190,0,0,0,66,0,129,0,109,0,0,0,240,0,193,0,61,0,141,0,170,0,89,0,0,0,206,0,0,0,95,0,42,0,0,0,45,0,0,0,0,0,0,0,79,0,0,0,243,0,0,0,113,0,83,0,112,0,104,0,202,0,209,0,104,0,78,0,120,0,232,0,7,0,0,0,116,0,221,0,241,0,2,0,188,0,65,0,74,0,126,0,0,0,0,0,0,0,46,0,0,0,58,0,0,0,166,0,0,0,218,0,190,0,44,0,201,0,0,0,202,0,0,0,248,0,103,0,41,0,71,0,0,0,91,0,0,0,0,0,59,0,45,0,0,0,171,0,94,0,0,0,203,0,146,0,214,0,143,0,65,0,0,0,64,0,219,0,15,0,166,0,35,0,202,0,234,0,123,0,233,0,0,0,100,0,0,0,6,0,0,0,192,0,195,0,240,0,255,0,4,0,129,0,0,0,16,0,215,0,7,0,4,0,234,0,88,0,0,0,183,0,161,0,27,0,199,0,0,0,163,0,108,0,53,0,156,0,0,0,5,0,247,0,0,0,81,0,202,0,213,0,96,0,82,0,249,0,198,0,101,0,170,0,106,0,60,0,0,0,155,0,226,0,141,0,0,0,0,0,13,0,76,0,60,0,0,0,244,0,0,0,183,0,29,0,200,0,109,0,43,0,0,0,86,0,153,0,202,0,212,0,82,0,187,0,0,0,185,0,245,0,73,0,117,0,240,0,40,0,67,0,36,0,95,0,0,0,96,0,160,0,208,0,119,0,0,0,15,0,86,0,0,0,255,0,223,0,79,0,21,0,108,0,0,0,246,0,56,0,11,0,130,0,78,0,67,0,82,0,51,0,0,0,115,0,106,0,104,0,97,0,104,0,0,0,0,0,89,0,153,0,0,0,0,0,0,0,2,0,237,0,149,0,76,0,34,0,232,0);
signal scenario_full  : scenario_type := (0,0,172,31,172,30,254,31,54,31,88,31,117,31,152,31,182,31,182,30,175,31,175,30,175,29,200,31,58,31,229,31,195,31,195,30,181,31,140,31,56,31,121,31,236,31,236,30,236,29,236,28,96,31,96,30,96,29,64,31,243,31,245,31,245,30,135,31,230,31,245,31,25,31,90,31,57,31,62,31,62,30,62,29,62,28,62,27,62,26,19,31,134,31,134,30,86,31,66,31,34,31,128,31,97,31,104,31,83,31,234,31,29,31,179,31,179,30,27,31,36,31,79,31,12,31,1,31,129,31,181,31,22,31,22,30,129,31,187,31,134,31,161,31,17,31,210,31,249,31,50,31,252,31,228,31,11,31,184,31,143,31,151,31,37,31,254,31,119,31,186,31,186,30,123,31,123,30,80,31,80,30,230,31,137,31,215,31,251,31,144,31,79,31,96,31,190,31,230,31,135,31,104,31,104,30,176,31,82,31,112,31,190,31,190,30,66,31,129,31,109,31,109,30,240,31,193,31,61,31,141,31,170,31,89,31,89,30,206,31,206,30,95,31,42,31,42,30,45,31,45,30,45,29,45,28,79,31,79,30,243,31,243,30,113,31,83,31,112,31,104,31,202,31,209,31,104,31,78,31,120,31,232,31,7,31,7,30,116,31,221,31,241,31,2,31,188,31,65,31,74,31,126,31,126,30,126,29,126,28,46,31,46,30,58,31,58,30,166,31,166,30,218,31,190,31,44,31,201,31,201,30,202,31,202,30,248,31,103,31,41,31,71,31,71,30,91,31,91,30,91,29,59,31,45,31,45,30,171,31,94,31,94,30,203,31,146,31,214,31,143,31,65,31,65,30,64,31,219,31,15,31,166,31,35,31,202,31,234,31,123,31,233,31,233,30,100,31,100,30,6,31,6,30,192,31,195,31,240,31,255,31,4,31,129,31,129,30,16,31,215,31,7,31,4,31,234,31,88,31,88,30,183,31,161,31,27,31,199,31,199,30,163,31,108,31,53,31,156,31,156,30,5,31,247,31,247,30,81,31,202,31,213,31,96,31,82,31,249,31,198,31,101,31,170,31,106,31,60,31,60,30,155,31,226,31,141,31,141,30,141,29,13,31,76,31,60,31,60,30,244,31,244,30,183,31,29,31,200,31,109,31,43,31,43,30,86,31,153,31,202,31,212,31,82,31,187,31,187,30,185,31,245,31,73,31,117,31,240,31,40,31,67,31,36,31,95,31,95,30,96,31,160,31,208,31,119,31,119,30,15,31,86,31,86,30,255,31,223,31,79,31,21,31,108,31,108,30,246,31,56,31,11,31,130,31,78,31,67,31,82,31,51,31,51,30,115,31,106,31,104,31,97,31,104,31,104,30,104,29,89,31,153,31,153,30,153,29,153,28,2,31,237,31,149,31,76,31,34,31,232,31);

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
