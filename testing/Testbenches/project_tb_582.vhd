-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_582 is
end project_tb_582;

architecture project_tb_arch_582 of project_tb_582 is
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

constant SCENARIO_LENGTH : integer := 456;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (163,0,0,0,103,0,71,0,24,0,162,0,15,0,0,0,248,0,72,0,155,0,139,0,0,0,0,0,131,0,0,0,45,0,0,0,0,0,41,0,242,0,247,0,220,0,186,0,160,0,0,0,92,0,243,0,138,0,109,0,223,0,95,0,23,0,180,0,102,0,222,0,46,0,0,0,242,0,0,0,199,0,133,0,244,0,0,0,0,0,71,0,155,0,210,0,215,0,196,0,34,0,218,0,110,0,137,0,14,0,86,0,189,0,124,0,0,0,0,0,231,0,32,0,0,0,210,0,176,0,0,0,171,0,245,0,0,0,32,0,102,0,53,0,155,0,194,0,247,0,181,0,105,0,216,0,207,0,112,0,150,0,166,0,183,0,32,0,0,0,45,0,243,0,131,0,230,0,145,0,86,0,45,0,85,0,96,0,0,0,0,0,119,0,158,0,106,0,134,0,0,0,195,0,0,0,45,0,143,0,0,0,29,0,93,0,125,0,0,0,143,0,48,0,224,0,0,0,0,0,153,0,59,0,0,0,253,0,197,0,231,0,168,0,218,0,184,0,222,0,211,0,0,0,247,0,180,0,2,0,29,0,178,0,165,0,65,0,241,0,64,0,7,0,15,0,0,0,238,0,0,0,145,0,14,0,168,0,214,0,30,0,14,0,255,0,190,0,0,0,64,0,0,0,52,0,71,0,230,0,226,0,104,0,134,0,89,0,0,0,85,0,247,0,13,0,86,0,119,0,0,0,0,0,0,0,0,0,0,0,0,0,232,0,7,0,117,0,111,0,72,0,219,0,36,0,0,0,204,0,61,0,13,0,201,0,0,0,0,0,251,0,127,0,0,0,0,0,28,0,107,0,0,0,22,0,111,0,92,0,203,0,0,0,16,0,100,0,153,0,230,0,0,0,0,0,6,0,0,0,251,0,126,0,213,0,129,0,157,0,103,0,29,0,29,0,99,0,0,0,101,0,193,0,0,0,101,0,0,0,208,0,108,0,211,0,92,0,95,0,0,0,91,0,182,0,0,0,57,0,45,0,28,0,202,0,16,0,232,0,30,0,103,0,196,0,26,0,109,0,169,0,76,0,115,0,238,0,113,0,144,0,129,0,18,0,0,0,49,0,237,0,203,0,188,0,0,0,223,0,119,0,166,0,122,0,6,0,136,0,0,0,83,0,77,0,100,0,78,0,159,0,220,0,176,0,0,0,171,0,132,0,187,0,132,0,7,0,181,0,174,0,196,0,0,0,58,0,138,0,254,0,237,0,15,0,177,0,0,0,53,0,215,0,0,0,226,0,189,0,117,0,114,0,196,0,10,0,205,0,40,0,190,0,0,0,184,0,162,0,83,0,0,0,48,0,223,0,106,0,13,0,102,0,63,0,218,0,0,0,0,0,0,0,76,0,126,0,41,0,191,0,6,0,0,0,201,0,220,0,219,0,250,0,97,0,39,0,0,0,89,0,0,0,0,0,0,0,0,0,152,0,0,0,127,0,170,0,97,0,242,0,246,0,174,0,230,0,0,0,0,0,56,0,43,0,0,0,0,0,153,0,0,0,130,0,159,0,254,0,131,0,246,0,23,0,103,0,205,0,22,0,136,0,0,0,176,0,38,0,212,0,103,0,62,0,215,0,143,0,139,0,251,0,153,0,189,0,219,0,8,0,0,0,246,0,20,0,0,0,101,0,155,0,14,0,16,0,0,0,0,0,0,0,189,0,230,0,1,0,0,0,95,0,69,0,108,0,251,0,208,0,242,0,127,0,132,0,183,0,187,0,10,0,31,0,0,0,176,0,51,0,98,0,47,0,176,0,54,0,178,0,6,0,68,0,139,0,27,0,47,0,0,0,0,0,107,0,34,0,114,0,60,0,28,0,109,0,25,0,32,0,96,0,132,0,148,0,230,0,0,0,253,0,35,0,0,0,52,0,45,0,0,0,128,0,84,0,216,0,67,0,0,0,0,0,34,0,33,0,0,0,0,0,14,0,200,0,0,0,137,0,50,0,0,0,147,0,169,0,176,0,28,0,160,0,79,0,49,0,52,0);
signal scenario_full  : scenario_type := (163,31,163,30,103,31,71,31,24,31,162,31,15,31,15,30,248,31,72,31,155,31,139,31,139,30,139,29,131,31,131,30,45,31,45,30,45,29,41,31,242,31,247,31,220,31,186,31,160,31,160,30,92,31,243,31,138,31,109,31,223,31,95,31,23,31,180,31,102,31,222,31,46,31,46,30,242,31,242,30,199,31,133,31,244,31,244,30,244,29,71,31,155,31,210,31,215,31,196,31,34,31,218,31,110,31,137,31,14,31,86,31,189,31,124,31,124,30,124,29,231,31,32,31,32,30,210,31,176,31,176,30,171,31,245,31,245,30,32,31,102,31,53,31,155,31,194,31,247,31,181,31,105,31,216,31,207,31,112,31,150,31,166,31,183,31,32,31,32,30,45,31,243,31,131,31,230,31,145,31,86,31,45,31,85,31,96,31,96,30,96,29,119,31,158,31,106,31,134,31,134,30,195,31,195,30,45,31,143,31,143,30,29,31,93,31,125,31,125,30,143,31,48,31,224,31,224,30,224,29,153,31,59,31,59,30,253,31,197,31,231,31,168,31,218,31,184,31,222,31,211,31,211,30,247,31,180,31,2,31,29,31,178,31,165,31,65,31,241,31,64,31,7,31,15,31,15,30,238,31,238,30,145,31,14,31,168,31,214,31,30,31,14,31,255,31,190,31,190,30,64,31,64,30,52,31,71,31,230,31,226,31,104,31,134,31,89,31,89,30,85,31,247,31,13,31,86,31,119,31,119,30,119,29,119,28,119,27,119,26,119,25,232,31,7,31,117,31,111,31,72,31,219,31,36,31,36,30,204,31,61,31,13,31,201,31,201,30,201,29,251,31,127,31,127,30,127,29,28,31,107,31,107,30,22,31,111,31,92,31,203,31,203,30,16,31,100,31,153,31,230,31,230,30,230,29,6,31,6,30,251,31,126,31,213,31,129,31,157,31,103,31,29,31,29,31,99,31,99,30,101,31,193,31,193,30,101,31,101,30,208,31,108,31,211,31,92,31,95,31,95,30,91,31,182,31,182,30,57,31,45,31,28,31,202,31,16,31,232,31,30,31,103,31,196,31,26,31,109,31,169,31,76,31,115,31,238,31,113,31,144,31,129,31,18,31,18,30,49,31,237,31,203,31,188,31,188,30,223,31,119,31,166,31,122,31,6,31,136,31,136,30,83,31,77,31,100,31,78,31,159,31,220,31,176,31,176,30,171,31,132,31,187,31,132,31,7,31,181,31,174,31,196,31,196,30,58,31,138,31,254,31,237,31,15,31,177,31,177,30,53,31,215,31,215,30,226,31,189,31,117,31,114,31,196,31,10,31,205,31,40,31,190,31,190,30,184,31,162,31,83,31,83,30,48,31,223,31,106,31,13,31,102,31,63,31,218,31,218,30,218,29,218,28,76,31,126,31,41,31,191,31,6,31,6,30,201,31,220,31,219,31,250,31,97,31,39,31,39,30,89,31,89,30,89,29,89,28,89,27,152,31,152,30,127,31,170,31,97,31,242,31,246,31,174,31,230,31,230,30,230,29,56,31,43,31,43,30,43,29,153,31,153,30,130,31,159,31,254,31,131,31,246,31,23,31,103,31,205,31,22,31,136,31,136,30,176,31,38,31,212,31,103,31,62,31,215,31,143,31,139,31,251,31,153,31,189,31,219,31,8,31,8,30,246,31,20,31,20,30,101,31,155,31,14,31,16,31,16,30,16,29,16,28,189,31,230,31,1,31,1,30,95,31,69,31,108,31,251,31,208,31,242,31,127,31,132,31,183,31,187,31,10,31,31,31,31,30,176,31,51,31,98,31,47,31,176,31,54,31,178,31,6,31,68,31,139,31,27,31,47,31,47,30,47,29,107,31,34,31,114,31,60,31,28,31,109,31,25,31,32,31,96,31,132,31,148,31,230,31,230,30,253,31,35,31,35,30,52,31,45,31,45,30,128,31,84,31,216,31,67,31,67,30,67,29,34,31,33,31,33,30,33,29,14,31,200,31,200,30,137,31,50,31,50,30,147,31,169,31,176,31,28,31,160,31,79,31,49,31,52,31);

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
