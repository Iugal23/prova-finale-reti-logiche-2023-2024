-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_395 is
end project_tb_395;

architecture project_tb_arch_395 of project_tb_395 is
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

constant SCENARIO_LENGTH : integer := 481;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,39,0,0,0,105,0,214,0,187,0,1,0,0,0,72,0,62,0,48,0,0,0,244,0,0,0,79,0,118,0,0,0,77,0,0,0,79,0,61,0,171,0,0,0,5,0,57,0,0,0,1,0,231,0,70,0,0,0,217,0,164,0,26,0,233,0,15,0,58,0,0,0,52,0,223,0,152,0,0,0,9,0,182,0,121,0,204,0,0,0,0,0,117,0,94,0,0,0,51,0,156,0,220,0,225,0,56,0,30,0,22,0,94,0,111,0,0,0,23,0,0,0,207,0,115,0,248,0,161,0,0,0,28,0,254,0,0,0,0,0,112,0,116,0,157,0,86,0,181,0,189,0,4,0,195,0,156,0,104,0,253,0,47,0,43,0,76,0,0,0,32,0,0,0,80,0,141,0,69,0,246,0,176,0,46,0,0,0,169,0,0,0,250,0,40,0,232,0,0,0,0,0,0,0,107,0,238,0,9,0,0,0,210,0,181,0,236,0,254,0,212,0,106,0,0,0,137,0,195,0,138,0,40,0,233,0,15,0,0,0,65,0,130,0,0,0,0,0,0,0,0,0,121,0,240,0,145,0,0,0,243,0,109,0,202,0,16,0,250,0,15,0,241,0,0,0,128,0,255,0,0,0,15,0,105,0,17,0,138,0,27,0,138,0,214,0,75,0,0,0,195,0,254,0,211,0,27,0,0,0,92,0,114,0,60,0,0,0,0,0,78,0,48,0,0,0,0,0,21,0,183,0,12,0,92,0,51,0,24,0,0,0,164,0,67,0,20,0,92,0,140,0,193,0,249,0,0,0,219,0,92,0,143,0,192,0,186,0,211,0,233,0,243,0,204,0,132,0,15,0,69,0,79,0,230,0,0,0,163,0,0,0,99,0,178,0,0,0,167,0,0,0,179,0,37,0,180,0,48,0,158,0,73,0,0,0,0,0,84,0,0,0,114,0,0,0,123,0,210,0,12,0,131,0,0,0,124,0,57,0,0,0,141,0,116,0,70,0,181,0,17,0,140,0,0,0,86,0,153,0,147,0,151,0,132,0,88,0,0,0,38,0,0,0,0,0,119,0,12,0,0,0,235,0,103,0,0,0,86,0,95,0,131,0,79,0,9,0,144,0,0,0,8,0,246,0,217,0,38,0,239,0,66,0,226,0,219,0,71,0,0,0,35,0,0,0,26,0,172,0,200,0,87,0,0,0,222,0,100,0,26,0,14,0,226,0,0,0,0,0,0,0,209,0,0,0,165,0,5,0,101,0,121,0,163,0,219,0,0,0,180,0,142,0,174,0,178,0,0,0,197,0,227,0,108,0,73,0,0,0,177,0,15,0,107,0,146,0,0,0,216,0,200,0,180,0,13,0,37,0,57,0,14,0,168,0,11,0,221,0,54,0,221,0,196,0,227,0,0,0,224,0,12,0,35,0,0,0,175,0,220,0,31,0,129,0,63,0,51,0,2,0,186,0,186,0,64,0,203,0,229,0,110,0,141,0,136,0,150,0,0,0,119,0,134,0,123,0,159,0,198,0,0,0,168,0,166,0,105,0,246,0,143,0,0,0,35,0,29,0,71,0,218,0,91,0,224,0,0,0,135,0,76,0,9,0,193,0,0,0,197,0,113,0,14,0,15,0,45,0,235,0,134,0,240,0,190,0,86,0,99,0,233,0,91,0,16,0,73,0,207,0,0,0,88,0,23,0,0,0,103,0,166,0,67,0,247,0,60,0,105,0,175,0,0,0,8,0,182,0,7,0,81,0,224,0,170,0,210,0,51,0,140,0,205,0,243,0,92,0,188,0,0,0,0,0,107,0,0,0,35,0,13,0,58,0,66,0,0,0,98,0,158,0,248,0,223,0,16,0,144,0,0,0,112,0,208,0,224,0,208,0,0,0,0,0,152,0,140,0,84,0,116,0,0,0,233,0,50,0,231,0,0,0,0,0,120,0,90,0,47,0,237,0,103,0,3,0,197,0,137,0,230,0,0,0,27,0,45,0,0,0,0,0,93,0,144,0,192,0,46,0,0,0,0,0,126,0,126,0,202,0,0,0,150,0,148,0,0,0,68,0,54,0,237,0,116,0,30,0,92,0,0,0,0,0,38,0,69,0,0,0,50,0,0,0,0,0,139,0,119,0,0,0,37,0,148,0,138,0);
signal scenario_full  : scenario_type := (0,0,39,31,39,30,105,31,214,31,187,31,1,31,1,30,72,31,62,31,48,31,48,30,244,31,244,30,79,31,118,31,118,30,77,31,77,30,79,31,61,31,171,31,171,30,5,31,57,31,57,30,1,31,231,31,70,31,70,30,217,31,164,31,26,31,233,31,15,31,58,31,58,30,52,31,223,31,152,31,152,30,9,31,182,31,121,31,204,31,204,30,204,29,117,31,94,31,94,30,51,31,156,31,220,31,225,31,56,31,30,31,22,31,94,31,111,31,111,30,23,31,23,30,207,31,115,31,248,31,161,31,161,30,28,31,254,31,254,30,254,29,112,31,116,31,157,31,86,31,181,31,189,31,4,31,195,31,156,31,104,31,253,31,47,31,43,31,76,31,76,30,32,31,32,30,80,31,141,31,69,31,246,31,176,31,46,31,46,30,169,31,169,30,250,31,40,31,232,31,232,30,232,29,232,28,107,31,238,31,9,31,9,30,210,31,181,31,236,31,254,31,212,31,106,31,106,30,137,31,195,31,138,31,40,31,233,31,15,31,15,30,65,31,130,31,130,30,130,29,130,28,130,27,121,31,240,31,145,31,145,30,243,31,109,31,202,31,16,31,250,31,15,31,241,31,241,30,128,31,255,31,255,30,15,31,105,31,17,31,138,31,27,31,138,31,214,31,75,31,75,30,195,31,254,31,211,31,27,31,27,30,92,31,114,31,60,31,60,30,60,29,78,31,48,31,48,30,48,29,21,31,183,31,12,31,92,31,51,31,24,31,24,30,164,31,67,31,20,31,92,31,140,31,193,31,249,31,249,30,219,31,92,31,143,31,192,31,186,31,211,31,233,31,243,31,204,31,132,31,15,31,69,31,79,31,230,31,230,30,163,31,163,30,99,31,178,31,178,30,167,31,167,30,179,31,37,31,180,31,48,31,158,31,73,31,73,30,73,29,84,31,84,30,114,31,114,30,123,31,210,31,12,31,131,31,131,30,124,31,57,31,57,30,141,31,116,31,70,31,181,31,17,31,140,31,140,30,86,31,153,31,147,31,151,31,132,31,88,31,88,30,38,31,38,30,38,29,119,31,12,31,12,30,235,31,103,31,103,30,86,31,95,31,131,31,79,31,9,31,144,31,144,30,8,31,246,31,217,31,38,31,239,31,66,31,226,31,219,31,71,31,71,30,35,31,35,30,26,31,172,31,200,31,87,31,87,30,222,31,100,31,26,31,14,31,226,31,226,30,226,29,226,28,209,31,209,30,165,31,5,31,101,31,121,31,163,31,219,31,219,30,180,31,142,31,174,31,178,31,178,30,197,31,227,31,108,31,73,31,73,30,177,31,15,31,107,31,146,31,146,30,216,31,200,31,180,31,13,31,37,31,57,31,14,31,168,31,11,31,221,31,54,31,221,31,196,31,227,31,227,30,224,31,12,31,35,31,35,30,175,31,220,31,31,31,129,31,63,31,51,31,2,31,186,31,186,31,64,31,203,31,229,31,110,31,141,31,136,31,150,31,150,30,119,31,134,31,123,31,159,31,198,31,198,30,168,31,166,31,105,31,246,31,143,31,143,30,35,31,29,31,71,31,218,31,91,31,224,31,224,30,135,31,76,31,9,31,193,31,193,30,197,31,113,31,14,31,15,31,45,31,235,31,134,31,240,31,190,31,86,31,99,31,233,31,91,31,16,31,73,31,207,31,207,30,88,31,23,31,23,30,103,31,166,31,67,31,247,31,60,31,105,31,175,31,175,30,8,31,182,31,7,31,81,31,224,31,170,31,210,31,51,31,140,31,205,31,243,31,92,31,188,31,188,30,188,29,107,31,107,30,35,31,13,31,58,31,66,31,66,30,98,31,158,31,248,31,223,31,16,31,144,31,144,30,112,31,208,31,224,31,208,31,208,30,208,29,152,31,140,31,84,31,116,31,116,30,233,31,50,31,231,31,231,30,231,29,120,31,90,31,47,31,237,31,103,31,3,31,197,31,137,31,230,31,230,30,27,31,45,31,45,30,45,29,93,31,144,31,192,31,46,31,46,30,46,29,126,31,126,31,202,31,202,30,150,31,148,31,148,30,68,31,54,31,237,31,116,31,30,31,92,31,92,30,92,29,38,31,69,31,69,30,50,31,50,30,50,29,139,31,119,31,119,30,37,31,148,31,138,31);

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
