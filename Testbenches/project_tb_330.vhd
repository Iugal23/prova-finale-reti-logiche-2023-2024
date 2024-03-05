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

constant SCENARIO_LENGTH : integer := 477;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (167,0,55,0,232,0,111,0,0,0,241,0,0,0,226,0,25,0,159,0,148,0,73,0,116,0,0,0,251,0,236,0,0,0,0,0,51,0,96,0,189,0,19,0,100,0,138,0,0,0,185,0,36,0,254,0,207,0,23,0,195,0,0,0,109,0,122,0,2,0,153,0,68,0,163,0,83,0,12,0,40,0,174,0,58,0,24,0,29,0,0,0,0,0,95,0,88,0,0,0,108,0,42,0,62,0,61,0,214,0,195,0,67,0,25,0,93,0,0,0,38,0,171,0,121,0,147,0,203,0,39,0,75,0,156,0,212,0,221,0,52,0,101,0,113,0,181,0,0,0,140,0,167,0,232,0,228,0,159,0,112,0,210,0,71,0,36,0,109,0,227,0,120,0,173,0,17,0,108,0,92,0,241,0,0,0,0,0,46,0,170,0,253,0,68,0,60,0,119,0,0,0,201,0,173,0,185,0,139,0,216,0,177,0,44,0,208,0,207,0,119,0,110,0,13,0,175,0,0,0,65,0,92,0,244,0,0,0,149,0,77,0,91,0,10,0,1,0,176,0,188,0,20,0,73,0,172,0,0,0,235,0,95,0,122,0,101,0,10,0,201,0,0,0,154,0,23,0,225,0,87,0,96,0,251,0,54,0,0,0,237,0,185,0,5,0,238,0,30,0,171,0,148,0,54,0,195,0,151,0,33,0,57,0,66,0,0,0,104,0,209,0,137,0,0,0,28,0,183,0,68,0,22,0,0,0,81,0,196,0,191,0,42,0,199,0,80,0,249,0,173,0,0,0,162,0,124,0,216,0,203,0,28,0,128,0,211,0,0,0,2,0,0,0,60,0,183,0,0,0,6,0,125,0,21,0,195,0,151,0,62,0,170,0,69,0,60,0,91,0,154,0,54,0,51,0,0,0,0,0,128,0,119,0,0,0,0,0,0,0,81,0,209,0,84,0,97,0,0,0,71,0,30,0,119,0,206,0,163,0,71,0,0,0,89,0,0,0,195,0,102,0,235,0,164,0,27,0,0,0,158,0,251,0,0,0,176,0,144,0,235,0,130,0,0,0,0,0,34,0,48,0,60,0,125,0,230,0,0,0,74,0,215,0,44,0,68,0,0,0,67,0,141,0,0,0,8,0,208,0,239,0,19,0,141,0,0,0,245,0,158,0,0,0,0,0,153,0,78,0,8,0,217,0,67,0,131,0,66,0,236,0,0,0,0,0,185,0,223,0,236,0,0,0,155,0,0,0,210,0,0,0,0,0,40,0,168,0,185,0,0,0,119,0,182,0,0,0,128,0,235,0,120,0,0,0,0,0,6,0,63,0,241,0,48,0,138,0,82,0,166,0,74,0,35,0,31,0,0,0,203,0,234,0,163,0,182,0,117,0,225,0,111,0,216,0,0,0,148,0,214,0,158,0,0,0,199,0,194,0,0,0,0,0,238,0,17,0,145,0,89,0,69,0,171,0,163,0,36,0,199,0,194,0,128,0,164,0,127,0,162,0,12,0,113,0,40,0,96,0,61,0,24,0,231,0,66,0,194,0,109,0,199,0,155,0,0,0,66,0,220,0,237,0,135,0,240,0,0,0,0,0,129,0,40,0,0,0,18,0,37,0,45,0,0,0,133,0,26,0,36,0,110,0,17,0,29,0,133,0,205,0,236,0,1,0,21,0,154,0,66,0,68,0,42,0,0,0,154,0,203,0,32,0,132,0,91,0,80,0,184,0,0,0,0,0,55,0,143,0,0,0,0,0,0,0,0,0,117,0,45,0,89,0,188,0,141,0,0,0,217,0,0,0,42,0,25,0,78,0,91,0,34,0,0,0,0,0,2,0,162,0,99,0,136,0,0,0,187,0,12,0,0,0,84,0,0,0,109,0,32,0,204,0,16,0,0,0,0,0,205,0,91,0,212,0,85,0,115,0,0,0,26,0,195,0,110,0,0,0,162,0,32,0,120,0,168,0,0,0,117,0,111,0,0,0,20,0,73,0,245,0,109,0,59,0,68,0,158,0,187,0,0,0,106,0,135,0,116,0,13,0,209,0,0,0,181,0,112,0,0,0,194,0,226,0,0,0,186,0,19,0,110,0,0,0,0,0,223,0,3,0,129,0,41,0,0,0,60,0,6,0,0,0);
signal scenario_full  : scenario_type := (167,31,55,31,232,31,111,31,111,30,241,31,241,30,226,31,25,31,159,31,148,31,73,31,116,31,116,30,251,31,236,31,236,30,236,29,51,31,96,31,189,31,19,31,100,31,138,31,138,30,185,31,36,31,254,31,207,31,23,31,195,31,195,30,109,31,122,31,2,31,153,31,68,31,163,31,83,31,12,31,40,31,174,31,58,31,24,31,29,31,29,30,29,29,95,31,88,31,88,30,108,31,42,31,62,31,61,31,214,31,195,31,67,31,25,31,93,31,93,30,38,31,171,31,121,31,147,31,203,31,39,31,75,31,156,31,212,31,221,31,52,31,101,31,113,31,181,31,181,30,140,31,167,31,232,31,228,31,159,31,112,31,210,31,71,31,36,31,109,31,227,31,120,31,173,31,17,31,108,31,92,31,241,31,241,30,241,29,46,31,170,31,253,31,68,31,60,31,119,31,119,30,201,31,173,31,185,31,139,31,216,31,177,31,44,31,208,31,207,31,119,31,110,31,13,31,175,31,175,30,65,31,92,31,244,31,244,30,149,31,77,31,91,31,10,31,1,31,176,31,188,31,20,31,73,31,172,31,172,30,235,31,95,31,122,31,101,31,10,31,201,31,201,30,154,31,23,31,225,31,87,31,96,31,251,31,54,31,54,30,237,31,185,31,5,31,238,31,30,31,171,31,148,31,54,31,195,31,151,31,33,31,57,31,66,31,66,30,104,31,209,31,137,31,137,30,28,31,183,31,68,31,22,31,22,30,81,31,196,31,191,31,42,31,199,31,80,31,249,31,173,31,173,30,162,31,124,31,216,31,203,31,28,31,128,31,211,31,211,30,2,31,2,30,60,31,183,31,183,30,6,31,125,31,21,31,195,31,151,31,62,31,170,31,69,31,60,31,91,31,154,31,54,31,51,31,51,30,51,29,128,31,119,31,119,30,119,29,119,28,81,31,209,31,84,31,97,31,97,30,71,31,30,31,119,31,206,31,163,31,71,31,71,30,89,31,89,30,195,31,102,31,235,31,164,31,27,31,27,30,158,31,251,31,251,30,176,31,144,31,235,31,130,31,130,30,130,29,34,31,48,31,60,31,125,31,230,31,230,30,74,31,215,31,44,31,68,31,68,30,67,31,141,31,141,30,8,31,208,31,239,31,19,31,141,31,141,30,245,31,158,31,158,30,158,29,153,31,78,31,8,31,217,31,67,31,131,31,66,31,236,31,236,30,236,29,185,31,223,31,236,31,236,30,155,31,155,30,210,31,210,30,210,29,40,31,168,31,185,31,185,30,119,31,182,31,182,30,128,31,235,31,120,31,120,30,120,29,6,31,63,31,241,31,48,31,138,31,82,31,166,31,74,31,35,31,31,31,31,30,203,31,234,31,163,31,182,31,117,31,225,31,111,31,216,31,216,30,148,31,214,31,158,31,158,30,199,31,194,31,194,30,194,29,238,31,17,31,145,31,89,31,69,31,171,31,163,31,36,31,199,31,194,31,128,31,164,31,127,31,162,31,12,31,113,31,40,31,96,31,61,31,24,31,231,31,66,31,194,31,109,31,199,31,155,31,155,30,66,31,220,31,237,31,135,31,240,31,240,30,240,29,129,31,40,31,40,30,18,31,37,31,45,31,45,30,133,31,26,31,36,31,110,31,17,31,29,31,133,31,205,31,236,31,1,31,21,31,154,31,66,31,68,31,42,31,42,30,154,31,203,31,32,31,132,31,91,31,80,31,184,31,184,30,184,29,55,31,143,31,143,30,143,29,143,28,143,27,117,31,45,31,89,31,188,31,141,31,141,30,217,31,217,30,42,31,25,31,78,31,91,31,34,31,34,30,34,29,2,31,162,31,99,31,136,31,136,30,187,31,12,31,12,30,84,31,84,30,109,31,32,31,204,31,16,31,16,30,16,29,205,31,91,31,212,31,85,31,115,31,115,30,26,31,195,31,110,31,110,30,162,31,32,31,120,31,168,31,168,30,117,31,111,31,111,30,20,31,73,31,245,31,109,31,59,31,68,31,158,31,187,31,187,30,106,31,135,31,116,31,13,31,209,31,209,30,181,31,112,31,112,30,194,31,226,31,226,30,186,31,19,31,110,31,110,30,110,29,223,31,3,31,129,31,41,31,41,30,60,31,6,31,6,30);

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
