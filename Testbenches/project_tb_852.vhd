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

constant SCENARIO_LENGTH : integer := 461;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (60,0,158,0,0,0,198,0,254,0,0,0,23,0,0,0,207,0,97,0,33,0,125,0,0,0,179,0,0,0,0,0,167,0,0,0,0,0,164,0,20,0,163,0,119,0,228,0,184,0,195,0,0,0,22,0,228,0,127,0,0,0,207,0,137,0,30,0,62,0,0,0,244,0,16,0,0,0,0,0,0,0,236,0,236,0,224,0,86,0,245,0,43,0,171,0,0,0,146,0,254,0,129,0,61,0,0,0,33,0,238,0,255,0,10,0,65,0,0,0,106,0,90,0,0,0,224,0,234,0,0,0,142,0,231,0,165,0,0,0,122,0,16,0,182,0,176,0,230,0,120,0,145,0,21,0,185,0,136,0,15,0,0,0,221,0,198,0,215,0,46,0,84,0,193,0,248,0,106,0,38,0,225,0,77,0,98,0,63,0,139,0,0,0,0,0,77,0,67,0,0,0,179,0,0,0,191,0,169,0,20,0,13,0,210,0,22,0,66,0,0,0,54,0,1,0,156,0,216,0,209,0,138,0,254,0,0,0,112,0,18,0,117,0,168,0,227,0,93,0,56,0,219,0,0,0,0,0,122,0,47,0,158,0,155,0,121,0,56,0,9,0,0,0,0,0,8,0,138,0,235,0,201,0,3,0,0,0,82,0,0,0,6,0,0,0,167,0,231,0,163,0,244,0,211,0,8,0,0,0,0,0,0,0,0,0,170,0,229,0,76,0,0,0,223,0,85,0,0,0,189,0,70,0,124,0,9,0,38,0,212,0,79,0,8,0,214,0,190,0,129,0,19,0,160,0,0,0,201,0,173,0,186,0,112,0,11,0,171,0,146,0,11,0,0,0,0,0,0,0,118,0,30,0,2,0,186,0,238,0,0,0,135,0,0,0,23,0,4,0,153,0,80,0,73,0,154,0,0,0,146,0,26,0,41,0,214,0,0,0,195,0,101,0,212,0,248,0,0,0,162,0,2,0,25,0,220,0,145,0,245,0,108,0,228,0,224,0,0,0,135,0,152,0,47,0,0,0,69,0,181,0,0,0,0,0,0,0,0,0,109,0,25,0,230,0,184,0,96,0,0,0,213,0,65,0,218,0,18,0,246,0,15,0,203,0,245,0,60,0,65,0,164,0,61,0,176,0,44,0,164,0,181,0,8,0,125,0,133,0,192,0,252,0,202,0,189,0,67,0,28,0,72,0,100,0,3,0,186,0,139,0,17,0,13,0,0,0,76,0,0,0,152,0,168,0,197,0,55,0,0,0,81,0,230,0,87,0,111,0,173,0,19,0,0,0,205,0,189,0,0,0,0,0,104,0,172,0,116,0,26,0,140,0,222,0,127,0,214,0,12,0,176,0,0,0,95,0,0,0,0,0,230,0,0,0,84,0,0,0,24,0,68,0,243,0,121,0,80,0,193,0,0,0,0,0,147,0,99,0,255,0,31,0,180,0,18,0,200,0,97,0,0,0,79,0,209,0,145,0,202,0,0,0,204,0,136,0,123,0,0,0,255,0,197,0,0,0,124,0,3,0,144,0,0,0,76,0,206,0,22,0,189,0,172,0,0,0,140,0,253,0,98,0,0,0,117,0,88,0,150,0,67,0,65,0,0,0,10,0,93,0,207,0,225,0,65,0,0,0,0,0,138,0,156,0,152,0,55,0,15,0,99,0,97,0,0,0,243,0,0,0,22,0,98,0,165,0,0,0,0,0,0,0,209,0,41,0,141,0,0,0,36,0,221,0,226,0,168,0,109,0,190,0,42,0,240,0,223,0,54,0,42,0,76,0,0,0,71,0,82,0,86,0,21,0,77,0,0,0,0,0,0,0,0,0,0,0,86,0,99,0,59,0,0,0,121,0,24,0,93,0,5,0,155,0,232,0,53,0,142,0,183,0,228,0,130,0,0,0,243,0,174,0,78,0,187,0,136,0,230,0,0,0,80,0,0,0,167,0,60,0,180,0,0,0,196,0,0,0,172,0,159,0,80,0,180,0,247,0,210,0,0,0,28,0,134,0,0,0,128,0,167,0,0,0,49,0,0,0,0,0,207,0,167,0,141,0,143,0,179,0);
signal scenario_full  : scenario_type := (60,31,158,31,158,30,198,31,254,31,254,30,23,31,23,30,207,31,97,31,33,31,125,31,125,30,179,31,179,30,179,29,167,31,167,30,167,29,164,31,20,31,163,31,119,31,228,31,184,31,195,31,195,30,22,31,228,31,127,31,127,30,207,31,137,31,30,31,62,31,62,30,244,31,16,31,16,30,16,29,16,28,236,31,236,31,224,31,86,31,245,31,43,31,171,31,171,30,146,31,254,31,129,31,61,31,61,30,33,31,238,31,255,31,10,31,65,31,65,30,106,31,90,31,90,30,224,31,234,31,234,30,142,31,231,31,165,31,165,30,122,31,16,31,182,31,176,31,230,31,120,31,145,31,21,31,185,31,136,31,15,31,15,30,221,31,198,31,215,31,46,31,84,31,193,31,248,31,106,31,38,31,225,31,77,31,98,31,63,31,139,31,139,30,139,29,77,31,67,31,67,30,179,31,179,30,191,31,169,31,20,31,13,31,210,31,22,31,66,31,66,30,54,31,1,31,156,31,216,31,209,31,138,31,254,31,254,30,112,31,18,31,117,31,168,31,227,31,93,31,56,31,219,31,219,30,219,29,122,31,47,31,158,31,155,31,121,31,56,31,9,31,9,30,9,29,8,31,138,31,235,31,201,31,3,31,3,30,82,31,82,30,6,31,6,30,167,31,231,31,163,31,244,31,211,31,8,31,8,30,8,29,8,28,8,27,170,31,229,31,76,31,76,30,223,31,85,31,85,30,189,31,70,31,124,31,9,31,38,31,212,31,79,31,8,31,214,31,190,31,129,31,19,31,160,31,160,30,201,31,173,31,186,31,112,31,11,31,171,31,146,31,11,31,11,30,11,29,11,28,118,31,30,31,2,31,186,31,238,31,238,30,135,31,135,30,23,31,4,31,153,31,80,31,73,31,154,31,154,30,146,31,26,31,41,31,214,31,214,30,195,31,101,31,212,31,248,31,248,30,162,31,2,31,25,31,220,31,145,31,245,31,108,31,228,31,224,31,224,30,135,31,152,31,47,31,47,30,69,31,181,31,181,30,181,29,181,28,181,27,109,31,25,31,230,31,184,31,96,31,96,30,213,31,65,31,218,31,18,31,246,31,15,31,203,31,245,31,60,31,65,31,164,31,61,31,176,31,44,31,164,31,181,31,8,31,125,31,133,31,192,31,252,31,202,31,189,31,67,31,28,31,72,31,100,31,3,31,186,31,139,31,17,31,13,31,13,30,76,31,76,30,152,31,168,31,197,31,55,31,55,30,81,31,230,31,87,31,111,31,173,31,19,31,19,30,205,31,189,31,189,30,189,29,104,31,172,31,116,31,26,31,140,31,222,31,127,31,214,31,12,31,176,31,176,30,95,31,95,30,95,29,230,31,230,30,84,31,84,30,24,31,68,31,243,31,121,31,80,31,193,31,193,30,193,29,147,31,99,31,255,31,31,31,180,31,18,31,200,31,97,31,97,30,79,31,209,31,145,31,202,31,202,30,204,31,136,31,123,31,123,30,255,31,197,31,197,30,124,31,3,31,144,31,144,30,76,31,206,31,22,31,189,31,172,31,172,30,140,31,253,31,98,31,98,30,117,31,88,31,150,31,67,31,65,31,65,30,10,31,93,31,207,31,225,31,65,31,65,30,65,29,138,31,156,31,152,31,55,31,15,31,99,31,97,31,97,30,243,31,243,30,22,31,98,31,165,31,165,30,165,29,165,28,209,31,41,31,141,31,141,30,36,31,221,31,226,31,168,31,109,31,190,31,42,31,240,31,223,31,54,31,42,31,76,31,76,30,71,31,82,31,86,31,21,31,77,31,77,30,77,29,77,28,77,27,77,26,86,31,99,31,59,31,59,30,121,31,24,31,93,31,5,31,155,31,232,31,53,31,142,31,183,31,228,31,130,31,130,30,243,31,174,31,78,31,187,31,136,31,230,31,230,30,80,31,80,30,167,31,60,31,180,31,180,30,196,31,196,30,172,31,159,31,80,31,180,31,247,31,210,31,210,30,28,31,134,31,134,30,128,31,167,31,167,30,49,31,49,30,49,29,207,31,167,31,141,31,143,31,179,31);

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
