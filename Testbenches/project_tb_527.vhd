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

constant SCENARIO_LENGTH : integer := 559;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (156,0,29,0,53,0,0,0,0,0,238,0,122,0,84,0,247,0,197,0,0,0,26,0,39,0,86,0,255,0,147,0,21,0,30,0,138,0,30,0,175,0,47,0,197,0,168,0,123,0,184,0,135,0,65,0,147,0,64,0,93,0,83,0,193,0,0,0,122,0,98,0,121,0,89,0,216,0,0,0,197,0,184,0,192,0,205,0,240,0,119,0,211,0,0,0,124,0,0,0,253,0,115,0,57,0,182,0,149,0,37,0,0,0,187,0,205,0,184,0,228,0,47,0,23,0,244,0,54,0,47,0,0,0,0,0,233,0,5,0,0,0,214,0,176,0,241,0,22,0,0,0,0,0,206,0,22,0,37,0,0,0,0,0,88,0,42,0,94,0,186,0,45,0,254,0,146,0,134,0,252,0,125,0,0,0,78,0,93,0,212,0,148,0,57,0,168,0,209,0,96,0,73,0,0,0,0,0,50,0,255,0,67,0,0,0,69,0,176,0,121,0,130,0,83,0,195,0,60,0,0,0,19,0,7,0,181,0,170,0,123,0,135,0,0,0,164,0,214,0,134,0,169,0,0,0,0,0,29,0,180,0,0,0,154,0,180,0,254,0,83,0,6,0,39,0,81,0,135,0,228,0,0,0,118,0,0,0,91,0,199,0,61,0,100,0,0,0,1,0,42,0,93,0,248,0,146,0,250,0,204,0,0,0,31,0,90,0,0,0,0,0,18,0,73,0,75,0,46,0,96,0,0,0,42,0,227,0,198,0,0,0,162,0,0,0,170,0,154,0,100,0,0,0,34,0,49,0,0,0,55,0,51,0,156,0,229,0,0,0,251,0,217,0,0,0,146,0,215,0,216,0,161,0,214,0,98,0,192,0,86,0,183,0,236,0,46,0,0,0,128,0,230,0,41,0,140,0,157,0,41,0,160,0,163,0,35,0,241,0,131,0,218,0,13,0,59,0,178,0,174,0,0,0,85,0,0,0,244,0,169,0,84,0,203,0,131,0,0,0,11,0,210,0,11,0,217,0,0,0,45,0,0,0,0,0,250,0,82,0,18,0,0,0,108,0,161,0,130,0,250,0,219,0,80,0,81,0,45,0,0,0,168,0,125,0,0,0,243,0,34,0,0,0,42,0,123,0,0,0,42,0,83,0,85,0,212,0,179,0,14,0,241,0,10,0,0,0,137,0,194,0,66,0,25,0,0,0,207,0,231,0,70,0,97,0,0,0,0,0,176,0,10,0,0,0,0,0,177,0,102,0,162,0,9,0,2,0,190,0,227,0,202,0,116,0,216,0,0,0,0,0,42,0,59,0,32,0,105,0,0,0,255,0,193,0,210,0,95,0,95,0,120,0,174,0,0,0,163,0,227,0,240,0,172,0,12,0,54,0,3,0,237,0,240,0,40,0,188,0,170,0,159,0,98,0,179,0,236,0,34,0,168,0,39,0,13,0,9,0,240,0,81,0,107,0,200,0,31,0,224,0,92,0,243,0,215,0,32,0,96,0,194,0,120,0,0,0,22,0,0,0,183,0,65,0,19,0,0,0,201,0,248,0,183,0,28,0,38,0,120,0,234,0,159,0,124,0,0,0,176,0,185,0,66,0,125,0,166,0,106,0,12,0,118,0,114,0,244,0,73,0,224,0,28,0,0,0,82,0,0,0,115,0,0,0,0,0,80,0,203,0,244,0,143,0,253,0,229,0,206,0,157,0,0,0,163,0,157,0,0,0,54,0,80,0,222,0,0,0,9,0,247,0,167,0,122,0,0,0,123,0,168,0,179,0,216,0,0,0,0,0,0,0,137,0,0,0,164,0,0,0,164,0,49,0,0,0,221,0,82,0,143,0,109,0,214,0,184,0,196,0,0,0,124,0,79,0,0,0,0,0,216,0,0,0,0,0,115,0,0,0,76,0,58,0,158,0,24,0,0,0,203,0,0,0,62,0,222,0,43,0,254,0,54,0,205,0,12,0,35,0,218,0,80,0,110,0,106,0,66,0,108,0,8,0,206,0,129,0,0,0,102,0,191,0,20,0,225,0,248,0,188,0,69,0,171,0,57,0,69,0,229,0,0,0,254,0,61,0,0,0,201,0,142,0,117,0,41,0,252,0,84,0,214,0,121,0,66,0,86,0,171,0,157,0,30,0,26,0,59,0,201,0,0,0,70,0,137,0,98,0,107,0,160,0,68,0,45,0,119,0,0,0,0,0,3,0,72,0,26,0,175,0,73,0,0,0,123,0,138,0,0,0,7,0,70,0,114,0,32,0,173,0,123,0,214,0,134,0,224,0,0,0,172,0,47,0,189,0,0,0,0,0,162,0,0,0,211,0,0,0,0,0,98,0,54,0,0,0,22,0,0,0,85,0,138,0,0,0,16,0,109,0,131,0,155,0,96,0,58,0,136,0,202,0,102,0,7,0,124,0,80,0,0,0,159,0,82,0,114,0,37,0,124,0,0,0,0,0,211,0,72,0,23,0,178,0,194,0,153,0,132,0,199,0,195,0);
signal scenario_full  : scenario_type := (156,31,29,31,53,31,53,30,53,29,238,31,122,31,84,31,247,31,197,31,197,30,26,31,39,31,86,31,255,31,147,31,21,31,30,31,138,31,30,31,175,31,47,31,197,31,168,31,123,31,184,31,135,31,65,31,147,31,64,31,93,31,83,31,193,31,193,30,122,31,98,31,121,31,89,31,216,31,216,30,197,31,184,31,192,31,205,31,240,31,119,31,211,31,211,30,124,31,124,30,253,31,115,31,57,31,182,31,149,31,37,31,37,30,187,31,205,31,184,31,228,31,47,31,23,31,244,31,54,31,47,31,47,30,47,29,233,31,5,31,5,30,214,31,176,31,241,31,22,31,22,30,22,29,206,31,22,31,37,31,37,30,37,29,88,31,42,31,94,31,186,31,45,31,254,31,146,31,134,31,252,31,125,31,125,30,78,31,93,31,212,31,148,31,57,31,168,31,209,31,96,31,73,31,73,30,73,29,50,31,255,31,67,31,67,30,69,31,176,31,121,31,130,31,83,31,195,31,60,31,60,30,19,31,7,31,181,31,170,31,123,31,135,31,135,30,164,31,214,31,134,31,169,31,169,30,169,29,29,31,180,31,180,30,154,31,180,31,254,31,83,31,6,31,39,31,81,31,135,31,228,31,228,30,118,31,118,30,91,31,199,31,61,31,100,31,100,30,1,31,42,31,93,31,248,31,146,31,250,31,204,31,204,30,31,31,90,31,90,30,90,29,18,31,73,31,75,31,46,31,96,31,96,30,42,31,227,31,198,31,198,30,162,31,162,30,170,31,154,31,100,31,100,30,34,31,49,31,49,30,55,31,51,31,156,31,229,31,229,30,251,31,217,31,217,30,146,31,215,31,216,31,161,31,214,31,98,31,192,31,86,31,183,31,236,31,46,31,46,30,128,31,230,31,41,31,140,31,157,31,41,31,160,31,163,31,35,31,241,31,131,31,218,31,13,31,59,31,178,31,174,31,174,30,85,31,85,30,244,31,169,31,84,31,203,31,131,31,131,30,11,31,210,31,11,31,217,31,217,30,45,31,45,30,45,29,250,31,82,31,18,31,18,30,108,31,161,31,130,31,250,31,219,31,80,31,81,31,45,31,45,30,168,31,125,31,125,30,243,31,34,31,34,30,42,31,123,31,123,30,42,31,83,31,85,31,212,31,179,31,14,31,241,31,10,31,10,30,137,31,194,31,66,31,25,31,25,30,207,31,231,31,70,31,97,31,97,30,97,29,176,31,10,31,10,30,10,29,177,31,102,31,162,31,9,31,2,31,190,31,227,31,202,31,116,31,216,31,216,30,216,29,42,31,59,31,32,31,105,31,105,30,255,31,193,31,210,31,95,31,95,31,120,31,174,31,174,30,163,31,227,31,240,31,172,31,12,31,54,31,3,31,237,31,240,31,40,31,188,31,170,31,159,31,98,31,179,31,236,31,34,31,168,31,39,31,13,31,9,31,240,31,81,31,107,31,200,31,31,31,224,31,92,31,243,31,215,31,32,31,96,31,194,31,120,31,120,30,22,31,22,30,183,31,65,31,19,31,19,30,201,31,248,31,183,31,28,31,38,31,120,31,234,31,159,31,124,31,124,30,176,31,185,31,66,31,125,31,166,31,106,31,12,31,118,31,114,31,244,31,73,31,224,31,28,31,28,30,82,31,82,30,115,31,115,30,115,29,80,31,203,31,244,31,143,31,253,31,229,31,206,31,157,31,157,30,163,31,157,31,157,30,54,31,80,31,222,31,222,30,9,31,247,31,167,31,122,31,122,30,123,31,168,31,179,31,216,31,216,30,216,29,216,28,137,31,137,30,164,31,164,30,164,31,49,31,49,30,221,31,82,31,143,31,109,31,214,31,184,31,196,31,196,30,124,31,79,31,79,30,79,29,216,31,216,30,216,29,115,31,115,30,76,31,58,31,158,31,24,31,24,30,203,31,203,30,62,31,222,31,43,31,254,31,54,31,205,31,12,31,35,31,218,31,80,31,110,31,106,31,66,31,108,31,8,31,206,31,129,31,129,30,102,31,191,31,20,31,225,31,248,31,188,31,69,31,171,31,57,31,69,31,229,31,229,30,254,31,61,31,61,30,201,31,142,31,117,31,41,31,252,31,84,31,214,31,121,31,66,31,86,31,171,31,157,31,30,31,26,31,59,31,201,31,201,30,70,31,137,31,98,31,107,31,160,31,68,31,45,31,119,31,119,30,119,29,3,31,72,31,26,31,175,31,73,31,73,30,123,31,138,31,138,30,7,31,70,31,114,31,32,31,173,31,123,31,214,31,134,31,224,31,224,30,172,31,47,31,189,31,189,30,189,29,162,31,162,30,211,31,211,30,211,29,98,31,54,31,54,30,22,31,22,30,85,31,138,31,138,30,16,31,109,31,131,31,155,31,96,31,58,31,136,31,202,31,102,31,7,31,124,31,80,31,80,30,159,31,82,31,114,31,37,31,124,31,124,30,124,29,211,31,72,31,23,31,178,31,194,31,153,31,132,31,199,31,195,31);

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
